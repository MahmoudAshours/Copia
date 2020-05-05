import 'package:copia/Moor/table.dart';
import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UploadPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<UploadPdfBloc>(context);
    final _dbloc = Provider.of<AppDatabase>(context);
    return Scaffold(
      backgroundColor: const Color(0xffEEEEED),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: 0.8,
              child: SizedBox(
                width: 50,
                height: 200,
                child: CustomPaint(
                  painter: Circle(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Opacity(
              opacity: 0.8,
              child: SizedBox(
                width: 50,
                height: 150,
                child: CustomPaint(
                  painter: Circle(),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 130.0, left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xffECB279),
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      'Upload your PDF',
                      style: GoogleFonts.copse(fontSize: 30),
                    )),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 100,
                height: 100,
                child: SvgPicture.asset(
                  'assets/images/books.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 100,
                height: 100,
                child: SvgPicture.asset(
                  'assets/images/shelves.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Material(
                    type: MaterialType.transparency,
                    child: Container(
                      width: 200,
                      child: TextField(
                        onChanged: (String title) => _bloc.pdfTitle = title,
                        decoration: InputDecoration(
                          hintText: 'Enter PDF title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Upload your PDF file'),
                      SizedBox(height: 10.0),
                      IconButton(
                          icon: Icon(Icons.picture_as_pdf),
                          onPressed: () => _bloc.getPDF())
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Upload a image preview'),
                      SizedBox(height: 10.0),
                      IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () => _bloc.getImageFromGallery())
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: FloatingActionButton(
                      onPressed: () {
                        final _pdf = PDFSData(
                            id: null,
                            pdfName: _bloc.getPdfTitle,
                            thumb: _bloc.getImage,
                            pdfAsset: _bloc.getPdf,
                            totalHours: 0,
                            insertedDate: DateTime.now());
                        _dbloc.insertPDF(_pdf).then(
                              (value) => Navigator.of(context).pop(),
                            );
                      },
                      child: Text('Done!'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Circle extends CustomPainter {
  Paint _paint = Paint()
    ..color = Color(0xff584846)
    ..strokeWidth = 2;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset.zero, 200, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
