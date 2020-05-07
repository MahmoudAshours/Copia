import 'package:copia/Screens/UploadPDF/uploadpdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${DateTime.now().day}',
                    style: TextStyle(
                        fontFamily: 'cormorant',
                        fontSize: 42,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Positioned(
                left: 30,
                top: 30,
                child: Text(
                  _getYear() + ' ${DateTime.now().year}',
                  style: TextStyle(
                      fontFamily: 'cormorant',
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => UploadPDF())),
            child: Container(
              child: Text(
                'Add new PDF',
                style: GoogleFonts.cormorant(
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
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
