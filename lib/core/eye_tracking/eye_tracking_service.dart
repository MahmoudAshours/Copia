import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'gaze_command_classifier.dart';

class EyeTrackingService {
  EyeTrackingService({GazeCommandClassifier? classifier})
    : _classifier = classifier ?? GazeCommandClassifier(),
      _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          performanceMode: FaceDetectorMode.fast,
          enableContours: false,
          enableLandmarks: false,
          enableTracking: false,
        ),
      );

  final GazeCommandClassifier _classifier;
  final FaceDetector _faceDetector;
  final StreamController<GazeCommand> _commandsController =
      StreamController<GazeCommand>.broadcast();

  CameraController? _cameraController;
  bool _processingFrame = false;
  int _frameCounter = 0;

  Stream<GazeCommand> get commands => _commandsController.stream;

  bool get isRunning => _cameraController?.value.isStreamingImages ?? false;

  Future<void> start() async {
    if (isRunning) {
      return;
    }
    final cameras = await availableCameras();
    final front = cameras.firstWhereOrNull(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    if (front == null) {
      throw StateError('No front camera available for eye tracking.');
    }

    final controller = CameraController(
      front,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await controller.initialize();
    _cameraController = controller;

    _classifier.resetCooldown();
    _frameCounter = 0;

    await controller.startImageStream((CameraImage image) async {
      if (_processingFrame) {
        return;
      }
      _frameCounter++;
      if (_frameCounter % 4 != 0) {
        return;
      }
      _processingFrame = true;
      try {
        final inputImage = _toInputImage(image, controller.description);
        final faces = await _faceDetector.processImage(inputImage);
        if (faces.isEmpty) {
          return;
        }
        final face = faces.first;
        final yaw = face.headEulerAngleY ?? 0;
        final pitch = face.headEulerAngleX ?? 0;
        final command = _classifier.classify(
          yaw: yaw,
          pitch: pitch,
          now: DateTime.now(),
        );
        if (command != GazeCommand.none) {
          _commandsController.add(command);
        }
      } catch (_) {
        // Ignore frame errors to keep stream stable.
      } finally {
        _processingFrame = false;
      }
    });
  }

  Future<void> stop() async {
    final controller = _cameraController;
    if (controller == null) {
      return;
    }
    if (controller.value.isStreamingImages) {
      await controller.stopImageStream();
    }
    await controller.dispose();
    _cameraController = null;
    _classifier.resetCooldown();
  }

  Future<void> dispose() async {
    await stop();
    await _faceDetector.close();
    await _commandsController.close();
  }

  InputImage _toInputImage(CameraImage image, CameraDescription description) {
    final bytes = _concatenatePlanes(image.planes);
    final rotation = InputImageRotationValue.fromRawValue(
      description.sensorOrientation,
    );
    final imageRotation = rotation ?? InputImageRotation.rotation0deg;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    final imageFormat = format ?? InputImageFormat.nv21;
    final size = Size(image.width.toDouble(), image.height.toDouble());
    final metadata = InputImageMetadata(
      size: size,
      rotation: imageRotation,
      format: imageFormat,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final writeBuffer = WriteBuffer();
    for (final plane in planes) {
      writeBuffer.putUint8List(plane.bytes);
    }
    return writeBuffer.done().buffer.asUint8List();
  }
}
