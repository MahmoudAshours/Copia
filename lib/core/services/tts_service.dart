import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path/path.dart' as p;

import 'file_storage_service.dart';

class TtsQueueState {
  const TtsQueueState({
    required this.chapters,
    required this.currentChapterIndex,
    required this.chapterProgress,
    required this.queueProgress,
    required this.speechRate,
    required this.isPlaying,
    required this.isLoaded,
    required this.sourceLabel,
    required this.currentWord,
  });

  const TtsQueueState.initial()
    : chapters = const <String>[],
      currentChapterIndex = 0,
      chapterProgress = 0,
      queueProgress = 0,
      speechRate = 0.45,
      isPlaying = false,
      isLoaded = false,
      sourceLabel = '',
      currentWord = '';

  final List<String> chapters;
  final int currentChapterIndex;
  final double chapterProgress;
  final double queueProgress;
  final double speechRate;
  final bool isPlaying;
  final bool isLoaded;
  final String sourceLabel;
  final String currentWord;

  String get currentChapterTitle {
    if (chapters.isEmpty || currentChapterIndex >= chapters.length) {
      return 'No chapter';
    }
    return 'Chapter ${currentChapterIndex + 1}';
  }

  TtsQueueState copyWith({
    List<String>? chapters,
    int? currentChapterIndex,
    double? chapterProgress,
    double? queueProgress,
    double? speechRate,
    bool? isPlaying,
    bool? isLoaded,
    String? sourceLabel,
    String? currentWord,
  }) {
    return TtsQueueState(
      chapters: chapters ?? this.chapters,
      currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
      chapterProgress: chapterProgress ?? this.chapterProgress,
      queueProgress: queueProgress ?? this.queueProgress,
      speechRate: speechRate ?? this.speechRate,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoaded: isLoaded ?? this.isLoaded,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      currentWord: currentWord ?? this.currentWord,
    );
  }
}

class TtsService {
  TtsService({required FileStorageService fileStorageService})
    : _fileStorageService = fileStorageService {
    _bindHandlers();
  }

  final FileStorageService _fileStorageService;
  final FlutterTts _tts = FlutterTts();
  final ValueNotifier<TtsQueueState> queueState = ValueNotifier(
    const TtsQueueState.initial(),
  );

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(queueState.value.speechRate);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
    _initialized = true;
  }

  void _bindHandlers() {
    _tts.setStartHandler(() {
      queueState.value = queueState.value.copyWith(isPlaying: true);
    });

    _tts.setProgressHandler((text, startOffset, endOffset, word) {
      final currentChapter = _safeCurrentChapter();
      if (currentChapter.isEmpty) {
        return;
      }
      final safeOffset = startOffset.clamp(0, currentChapter.length);
      final progress = currentChapter.isEmpty
          ? 0.0
          : safeOffset / currentChapter.length;
      final current = queueState.value;
      queueState.value = current.copyWith(
        chapterProgress: progress,
        queueProgress: _computeQueueProgress(current, progress),
        currentWord: word,
      );
    });

    _tts.setCompletionHandler(() async {
      final state = queueState.value;
      final nextIndex = state.currentChapterIndex + 1;
      if (nextIndex < state.chapters.length) {
        queueState.value = state.copyWith(
          currentChapterIndex: nextIndex,
          chapterProgress: 0,
          queueProgress: nextIndex / state.chapters.length,
          isPlaying: false,
          currentWord: '',
        );
        await speakCurrentChapter();
        return;
      }
      queueState.value = state.copyWith(
        chapterProgress: 1,
        queueProgress: 1,
        isPlaying: false,
        currentWord: '',
      );
    });

    _tts.setCancelHandler(() {
      queueState.value = queueState.value.copyWith(
        isPlaying: false,
        currentWord: '',
      );
    });

    _tts.setErrorHandler((_) {
      queueState.value = queueState.value.copyWith(
        isPlaying: false,
        currentWord: '',
      );
    });
  }

  Future<void> loadQueue({
    required String text,
    required String sourceLabel,
  }) async {
    await initialize();

    final normalized = _normalizeText(text);
    if (normalized.isEmpty) {
      throw StateError('No text to read.');
    }

    final chapters = _splitIntoChapters(normalized);
    queueState.value = TtsQueueState(
      chapters: chapters,
      currentChapterIndex: 0,
      chapterProgress: 0,
      queueProgress: 0,
      speechRate: queueState.value.speechRate,
      isPlaying: false,
      isLoaded: true,
      sourceLabel: sourceLabel,
      currentWord: '',
    );
  }

  Future<void> speakCurrentChapter() async {
    await initialize();
    final chapter = _safeCurrentChapter();
    if (chapter.isEmpty) {
      throw StateError('No loaded chapter to read.');
    }

    await _tts.stop();
    final state = queueState.value;
    queueState.value = state.copyWith(
      chapterProgress: 0,
      queueProgress: _computeQueueProgress(state, 0),
      currentWord: '',
    );
    await _tts.speak(chapter);
  }

  Future<void> stop() async {
    await _tts.stop();
    queueState.value = queueState.value.copyWith(
      isPlaying: false,
      currentWord: '',
    );
  }

  Future<void> nextChapter() async {
    final state = queueState.value;
    if (!state.isLoaded ||
        state.currentChapterIndex >= state.chapters.length - 1) {
      return;
    }
    await _tts.stop();
    queueState.value = state.copyWith(
      currentChapterIndex: state.currentChapterIndex + 1,
      chapterProgress: 0,
      queueProgress: (state.currentChapterIndex + 1) / state.chapters.length,
      isPlaying: false,
      currentWord: '',
    );
    await speakCurrentChapter();
  }

  Future<void> previousChapter() async {
    final state = queueState.value;
    if (!state.isLoaded || state.currentChapterIndex <= 0) {
      return;
    }
    await _tts.stop();
    queueState.value = state.copyWith(
      currentChapterIndex: state.currentChapterIndex - 1,
      chapterProgress: 0,
      queueProgress: (state.currentChapterIndex - 1) / state.chapters.length,
      isPlaying: false,
      currentWord: '',
    );
    await speakCurrentChapter();
  }

  Future<void> selectChapter(int index) async {
    final state = queueState.value;
    if (!state.isLoaded || index < 0 || index >= state.chapters.length) {
      return;
    }
    await _tts.stop();
    queueState.value = state.copyWith(
      currentChapterIndex: index,
      chapterProgress: 0,
      queueProgress: index / state.chapters.length,
      isPlaying: false,
      currentWord: '',
    );
    await speakCurrentChapter();
  }

  Future<void> setSpeechRate(double rate) async {
    await initialize();
    final bounded = rate.clamp(0.2, 0.8);
    await _tts.setSpeechRate(bounded);
    queueState.value = queueState.value.copyWith(speechRate: bounded);
  }

  Future<String> synthesizeToAudiobook({
    required String text,
    required String baseName,
  }) async {
    if (text.trim().isEmpty) {
      throw StateError('No text to convert.');
    }

    await initialize();
    final sanitized = baseName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final fileName = '${sanitized.isEmpty ? 'copia_audio' : sanitized}.wav';

    final docsDir = await _fileStorageService.managedDirectory('audio_books');
    final targetPath = p.join(docsDir.path, fileName);

    final success = await _tts.synthesizeToFile(text, targetPath);
    if (success != 1 && success != true) {
      throw StateError('System TTS failed to synthesize audio file.');
    }

    final file = File(targetPath);
    if (!file.existsSync()) {
      throw StateError('Audiobook file not found after synthesis.');
    }

    return file.path;
  }

  Future<void> clearQueue() async {
    await _tts.stop();
    queueState.value = const TtsQueueState.initial();
  }

  Future<void> dispose() async {
    await _tts.stop();
    queueState.dispose();
  }

  String _safeCurrentChapter() {
    final state = queueState.value;
    if (!state.isLoaded || state.chapters.isEmpty) {
      return '';
    }
    if (state.currentChapterIndex < 0 ||
        state.currentChapterIndex >= state.chapters.length) {
      return '';
    }
    return state.chapters[state.currentChapterIndex];
  }

  List<String> _splitIntoChapters(String text) {
    final paragraphs = text
        .split(RegExp(r'\n\s*\n'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final chapters = <String>[];
    final buffer = StringBuffer();

    for (final paragraph in paragraphs) {
      if (buffer.length + paragraph.length > 1400 && buffer.isNotEmpty) {
        chapters.add(buffer.toString().trim());
        buffer.clear();
      }
      if (buffer.isNotEmpty) {
        buffer.writeln();
        buffer.writeln();
      }
      buffer.write(paragraph);
    }

    if (buffer.isNotEmpty) {
      chapters.add(buffer.toString().trim());
    }

    if (chapters.isEmpty) {
      return <String>[text];
    }

    return chapters;
  }

  String _normalizeText(String input) {
    return input
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  double _computeQueueProgress(TtsQueueState state, double chapterProgress) {
    if (state.chapters.isEmpty) {
      return 0;
    }
    final chapterIndex = state.currentChapterIndex.clamp(
      0,
      state.chapters.length - 1,
    );
    final normalizedChapterProgress = chapterProgress.clamp(0, 1);
    return ((chapterIndex + normalizedChapterProgress) / state.chapters.length)
        .clamp(0, 1);
  }
}
