import 'package:copia/Screens/StatsScreen/stats_screen.dart';
import 'package:copia/Screens/UploadPDF/uploadpdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neumorphic/neumorphic.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
          height: 100,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 20.0, bottom: 20.0),
                  child: NeuText(
                    '${DateTime.now().day}',
                    depth: 10,
                    spread: 1,
                    style:  TextStyle(fontFamily: 'cormorant',
                        fontSize: 42, color: Color(0xffAAABAD)),
                  ),
                ),
              ),
              Positioned(
                left: 30,
                top: 30,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NeuText(
                    _getYear() + ' ${DateTime.now().year}',
                    depth: 5,
                    spread: 0.7,
                    style:  TextStyle(fontFamily: 'cormorant',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffAAABAD)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: NeuButton(
            decoration: NeumorphicDecoration(
              color: Color(0xff2D3036),
              shape: BoxShape.circle,
            ),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => UploadPDF())),
            child: FaIcon(FontAwesomeIcons.plusCircle,
                color: Color(0xf2EA4F2C), size: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: NeuButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => StatsScreen())),
            decoration: NeumorphicDecoration(
              color: Color(0xff2D3036),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              FontAwesomeIcons.chartLine,
              color: Colors.greenAccent,
              size: 25,
            ),
          ),
        )
      ],
    );
  }

  String _getYear() {
    switch (DateTime.now().month) {
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mars';
        break;
      case 4:
        return 'April';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'June';
        break;
      case 7:
        return 'July';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'OCt';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
      default:
        return 'month';
    }
  }
}
