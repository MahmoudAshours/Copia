import 'package:copia/Hive/database.dart';
import 'package:copia/Provider/pdfscreen_bloc.dart';
import 'package:copia/Provider/prov_db.dart';
import 'package:copia/Screens/PDFScreen/bookmark_list.dart';
import 'package:copia/Screens/PDFScreen/bookmark_pdf.dart';
import 'package:copia/Screens/PDFScreen/pdf_audio.dart';
import 'package:copia/Screens/PDFScreen/pdf_document.dart';
import 'package:copia/Screens/PDFScreen/pdf_notes.dart';
import 'package:copia/Screens/PDFScreen/pdf_screenshot.dart';
import 'package:copia/Screens/PDFScreen/share_page.dart';
import 'package:copia/Utils/owl_icons.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Axis direction = Axis.horizontal;
  final DateTime _initDateTime = DateTime.now();
  bool _hideFab = false;
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
    final PDFDB _lastPdf = Hive.box('pdfDB').getAt(index);
    var _timeSpentReading = DateTime.now().difference(_initDateTime).inSeconds;
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
      totalHours: (_lastPdf.totalHours ?? 0) + _timeSpentReading,
    );
    Hive.box('pdfDB')
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
        floatingActionButton: _circularFab(_dbProvider, index, _pdfProvider),
        // bottomNavigationBar: BottomAudioPlayer(index: index, fab: _hideFab),
        backgroundColor: const Color(0xff26292D),
        body: GestureDetector(
          onTap: () => _hideFloatingActionBar(_pdfProvider),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xff26292D),
            child: RepaintBoundary(
              key: _pdfProvider.scr,
              child: Stack(
                children: <Widget>[
                  PdfView(
                      controller: _pdfController,
                      pageLoader: SpinKitChasingDots(color: Colors.blue),
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
                  SafeArea(
                    minimum: EdgeInsets.all(10),
                    child: Icon(
                      Owl.animal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _hideFloatingActionBar(PDFScreenBloc _bloc) {
    setState(() {
      if (_hideFab) {
        _hideFab = false;
      } else {
        _hideFab = true;
      }
    });
  }

  AnimatedOpacity _circularFab(
      ProviderDB _bloc, int index, PDFScreenBloc _pdfBloc) {
    return AnimatedOpacity(
      opacity: _hideFab ? 0.0 : 1.0,
      duration: Duration(milliseconds: 400),
      child: FabCircularMenu(
        fabCloseColor: Colors.black,
        ringColor: Color(0xff26292D),
        fabColor: Color(0xf2EA4F2C),
        fabSize: 40,
        fabElevation: 2.5,
        animationCurve: Curves.easeInOutCirc,
        fabCloseIcon: Icon(Owl.animal, color: Colors.white),
        animationDuration: Duration(milliseconds: 500),
        fabOpenIcon: Icon(Owl.animal, color: Colors.white),
        children: <Widget>[
          BookmarkPdf(index: index, currentPage: currentPage),
          BookmarkList(index: index, pdfController: _pdfController),
          PdfAudio(index),
          IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Icons.arrow_left)),
          _orientation(),
          PdfNotes(index: index, currentPage: currentPage),
          PdfScreenshot(),
          PdfDocumentViewer(index),
          SharePage(),
        ],
      ),
    );
  }

  _orientation() {
    return IconButton(
      icon: FaIcon(
        FontAwesomeIcons.syncAlt,
        color: Colors.white60,
      ),
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
      initialPage: Hive.box('pdfDB').getAt(index).lastVisitedPage ?? 1,
      viewportFraction: 1.0,
    );
    setState(() => currentPage = _pdfController.initialPage);
  }
}
