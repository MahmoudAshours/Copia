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
              children: <Widget>[MostReadChart(_pdfs)],
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
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
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
                    rod.y.round().toString(),
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
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
                    if(value.toInt()==i)
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
                      y: widget.pdfs[i].totalHours.toDouble(),
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
}
