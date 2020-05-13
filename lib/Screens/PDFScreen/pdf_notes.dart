import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PdfNotes extends StatefulWidget {
  @override
  _PdfNotesState createState() => _PdfNotesState();
}

class _PdfNotesState extends State<PdfNotes> {
  ScrollController _controller;
  double height = 100;
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.note),
      onPressed: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) {
              _controller.addListener(
                () {
                  if (_controller.position.userScrollDirection ==
                      ScrollDirection.reverse) {
                    setState(() => height = MediaQuery.of(context).size.height);
                  }
                },
              );
              return AnimatedContainer(
                height: height,
                duration: Duration(seconds: 1),
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    children: <Widget>[
                      TextField(),
                      FloatingActionButton(onPressed: () {})
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
