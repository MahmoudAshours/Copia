import 'package:copia/Hive/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEEEED),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('name').listenable(),
        builder: (_, Box snapshot, Widget widget) {
          List<PDFDB> _pdfs = Hive.box('name').values.toList().cast<PDFDB>();
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                MostReadChart(_pdfs),
                MostBookmarkedChart(_pdfs),
                AudioDocsChart(_pdfs)
              ],
            ),
          );
        },
      ),
    );
  }
}

class MostReadChart extends StatefulWidget {
  final List<PDFDB> pdfs;
  MostReadChart(this.pdfs);
  @override
  State<StatefulWidget> createState() => MostReadChartState();
}

class MostReadChartState extends State<MostReadChart> {
  @override
  Widget build(BuildContext context) {
    var _maximumTime = _getMaxTime();
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _maximumTime,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 8,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    rod.y.round().toString() + ' mins',
                    TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            axisTitleData: FlAxisTitleData(
              topTitle: AxisTitle(
                titleText: 'Most Read books',
                reservedSize: 30,
                margin: 50,
                textStyle: TextStyle(color: Colors.white, fontSize: 27),
                showTitle: true,
              ),
              show: true,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                  color: const Color(0xff7589a2),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                margin: 20,
                getTitles: (double value) {
                  for (var i = 0; i < widget.pdfs.length; i++) {
                    if (value.toInt() == i)
                      return widget.pdfs[i].pdfName.toUpperCase();
                  }
                  return 'Nothing to show';
                },
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              for (var i = 0; i < widget.pdfs.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      y: widget.pdfs[i].totalHours.toDouble() / 60,
                      color: Colors.lightBlueAccent,
                    )
                  ],
                  showingTooltipIndicators: [0],
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _getMaxTime() {
    if (widget.pdfs.isNotEmpty) {
      widget.pdfs.sort((b, a) => a.totalHours.compareTo(b.totalHours));
      final _sortedPDF = widget.pdfs[0];
      return (_sortedPDF.totalHours / 60).round().toDouble();
    }
    return 0;
  }
}

class MostBookmarkedChart extends StatefulWidget {
  final List<PDFDB> pdfs;
  MostBookmarkedChart(this.pdfs);
  @override
  State<StatefulWidget> createState() => MostBookmarkedChartState();
}

class MostBookmarkedChartState extends State<MostBookmarkedChart> {
  @override
  Widget build(BuildContext context) {
    var _maximumTime = _getMaxBookmarks();
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _maximumTime,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(10),
                fitInsideVertically: true,
                tooltipBottomMargin: 1,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    rod.y.round().toString() + ' bookmarked',
                    TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            axisTitleData: FlAxisTitleData(
              topTitle: AxisTitle(
                titleText: 'Most Bookmarked books',
                reservedSize: 30,
                margin: 30,
                textStyle: TextStyle(color: Colors.white, fontSize: 27),
                showTitle: true,
              ),
              show: true,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                  color: const Color(0xff7589a2),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                margin: 20,
                getTitles: (double value) {
                  for (var i = 0; i < widget.pdfs.length; i++) {
                    if (value.toInt() == i)
                      return widget.pdfs[i].pdfName.toUpperCase();
                  }
                  return 'Nothing to show';
                },
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              for (var i = 0; i < widget.pdfs.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      y: (widget.pdfs[i].bookmarked != null
                              ? widget.pdfs[i].bookmarked.length
                              : 0)
                          .toDouble(),
                      color: Colors.lightBlueAccent,
                    )
                  ],
                  showingTooltipIndicators: [0],
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _getMaxBookmarks() {
    if (widget.pdfs.isNotEmpty) {
      widget.pdfs.sort((b, a) => a.totalHours.compareTo(b.totalHours));
      final _sortedPDF = widget.pdfs[0];

      return (_sortedPDF?.bookmarked == null ? 0 : _sortedPDF.bookmarked.length)
          ?.toDouble();
    }
    return 0;
  }
}

class AudioDocsChart extends StatefulWidget {
  final List<PDFDB> pdfs;
  AudioDocsChart(this.pdfs);
  @override
  State<StatefulWidget> createState() => AudioDocsChartState();
}

class AudioDocsChartState extends State<AudioDocsChart> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (pieTouchResponse) {
                          setState(
                            () {
                              if (pieTouchResponse.touchInput
                                      is FlLongPressEnd ||
                                  pieTouchResponse.touchInput is FlPanEnd ||
                                  pieTouchResponse.touchInput
                                      is FlTouchNormalInput) {
                                touchedIndex = -1;
                              } else {
                                touchedIndex =
                                    pieTouchResponse.touchedSectionIndex;
                              }
                            },
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'Audio files',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Document Files',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.red,
                  text: 'Bookmarks',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.purple,
                  text: 'PDFs count',
                  isSquare: false,
                ),
              ],
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final double fontSize = isTouched ? 25 : 16;
        final double radius = isTouched ? 60 : 50;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xff0293ee),
              value: _getAudioFilesCount(),
              title: _getAudioFilesCount() == 0
                  ? ''
                  : '${_getAudioFilesCount().toInt()}',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          case 1:
            return PieChartSectionData(
              color: const Color(0xfff8b250),
              value: _getDocumentFilesCount() ?? 0,
              title: _getDocumentFilesCount() == 0
                  ? ''
                  : '${_getDocumentFilesCount().toInt()}',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          case 2:
            return PieChartSectionData(
              color: Colors.red,
              value: _getTotalBookmarksCount(),
              title: '${_getTotalBookmarksCount().toInt()}',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          case 3:
            return PieChartSectionData(
              color: Colors.purple,
              value: _getTotalPDFsCount(),
              title: '${_getTotalPDFsCount().toInt()}',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
          default:
            return PieChartSectionData(
              color: const Color(0xff0293ee),
              value: 0,
              title: 'Nothing to show yet',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)),
            );
        }
      },
    );
  }

  double _getAudioFilesCount() {
    var count = 0;
    for (var i = 0; i < widget.pdfs.length; i++) {
      if (widget.pdfs[i].soundPath != null) count++;
    }
    return count.toDouble();
  }

  double _getDocumentFilesCount() {
    var count = 0;
    for (var i = 0; i < widget.pdfs.length; i++) {
      if (widget.pdfs[i].documentPath != null) count++;
    }
    return count.toDouble();
  }

  double _getTotalBookmarksCount() {
    var count = 0;
    for (var i = 0; i < widget.pdfs.length; i++) {
      count += widget.pdfs[i].bookmarked.length;
    }
    return count.toDouble();
  }

  double _getTotalPDFsCount() => widget.pdfs.length.toDouble();
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
