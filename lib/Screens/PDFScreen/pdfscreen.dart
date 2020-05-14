import 'package:copia/Hive/database.dart';
import 'package:copia/Provider/pdfscreen_bloc.dart';
import 'package:copia/Provider/prov_db.dart';
import 'package:copia/Screens/PDFScreen/bookmark_list.dart';
import 'package:copia/Screens/PDFScreen/bookmark_pdf.dart';
import 'package:copia/Screens/PDFScreen/bottom_audioPlayer.dart';
import 'package:copia/Screens/PDFScreen/pdf_audio.dart';
import 'package:copia/Screens/PDFScreen/pdf_document.dart';
import 'package:copia/Screens/PDFScreen/pdf_notes.dart';
import 'package:copia/Screens/PDFScreen/pdf_screenshot.dart';
import 'package:copia/Utils/owl_icons.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:provider/provider.dart';

class PDFScreen extends StatefulWidget {
  final PDFDB snapshot;
  final int index;
  PDFScreen({this.snapshot, this.index});
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  int index;
  PdfController _pdfController;
  int currentPage;
  bool hideFab = false;
  Axis direction = Axis.horizontal;

  @override
  void initState() {
    initPage();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _update();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    final PDFDB _lastPdf = Hive.box('name').getAt(index);
    final _pdf = PDFDB(
      bookmarked: _lastPdf.bookmarked,
      insertedDate: _lastPdf.insertedDate,
      lastSeenDate: _lastPdf.lastSeenDate,
      lastVisitedPage: currentPage,
      pdfAsset: _lastPdf.pdfAsset,
      pdfName: _lastPdf.pdfName,
      thumb: _lastPdf.thumb,
      documentPath: _lastPdf.documentPath,
      pageNote: _lastPdf.pageNote,
      soundPath: _lastPdf.soundPath,
      totalHours: _lastPdf.totalHours,
    );
    Hive.box('name')
        .putAt(index, _pdf)
        .then((value) => _pdfController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _dbProvider = Provider.of<ProviderDB>(context);
    final _pdfProvider = Provider.of<PDFScreenBloc>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: _circularFab(_dbProvider, index),
        bottomNavigationBar: BottomAudioPlayer(index: index, hideFab: hideFab),
        backgroundColor: const Color(0xffEEEEED),
        body: GestureDetector(
          onTap: () => _hideFloatingActionBar(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xffEEEEED),
            child: RepaintBoundary(
              key: _pdfProvider.scr,
              child: PdfView(
                  controller: _pdfController,
                  documentLoader: Center(
                    child: const SpinKitPouringHourglass(color: Colors.black),
                  ),
                  onDocumentError: (err) => Navigator.of(context).pop(),
                  renderer: (PdfPage page) => page.render(
                        width: page.width * 2,
                        height: page.height * 2,
                        format: PdfPageFormat.PNG,
                        backgroundColor: '#EEEEED',
                      ),
                  errorBuilder: (e) {
                    return Container(
                      child: Text('error'),
                      width: 200,
                      height: 200,
                    );
                  },
                  pageSnapping: true,
                  scrollDirection: direction,
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (int currPage) =>
                      setState(() => currentPage = currPage)),
            ),
          ),
        ),
      ),
    );
  }

  _hideFloatingActionBar() {
    if (hideFab) {
      setState(() {
        hideFab = false;
      });
    } else {
      setState(() {
        hideFab = true;
      });
    }
  }

  AnimatedOpacity _circularFab(ProviderDB _bloc, int index) {
    return AnimatedOpacity(
      opacity: hideFab ? 0.0 : 1.0,
      duration: Duration(milliseconds: 400),
      child: FabCircularMenu(
        fabCloseColor: Colors.black,
        ringColor: Color(0xffA64848),
        fabColor: Colors.white,
        fabSize: 40,
        fabElevation: 2.5,
        animationCurve: Curves.easeInOutCirc,
        fabCloseIcon: Icon(Owl.animal, color: Colors.black),
        animationDuration: Duration(milliseconds: 500),
        fabOpenIcon: Icon(Owl.animal, color: Colors.white),
        children: <Widget>[
          BookmarkPdf(index: index, currentPage: currentPage),
          BookmarkList(index: index, pdfController: _pdfController),
          PdfAudio(index),
          IconButton(
            icon: Icon(Icons.border_horizontal),
            onPressed: () {
              setState(
                () {
                  if (direction == Axis.horizontal) {
                    direction = Axis.vertical;
                  } else {
                    direction = Axis.horizontal;
                  }
                },
              );
            },
          ),
          PdfNotes(),
          PdfScreenshot(),
          PdfDocumentViewer(index)
        ],
      ),
    );
  }

  void _update() {
    final _bloc = Provider.of<ProviderDB>(context);
    _bloc.updateLastSeen(widget.snapshot, widget.index);
  }

  void initPage() async {
    setState(() => index = widget.index);
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.snapshot.pdfAsset),
      initialPage: Hive.box('name').getAt(index).lastVisitedPage ?? 1,
      viewportFraction: 1.2,
    );
    setState(() => currentPage = _pdfController.initialPage);
  }
}
