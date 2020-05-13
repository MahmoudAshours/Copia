import 'package:copia/Screens/ControllerScreen/controller_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'styles.dart';
import 'circle_progress_bar.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<String> nameImages = [
    'assets/images/introImages/intro_books.svg',
    'assets/images/introImages/reading.svg',
    'assets/images/introImages/reading_time.svg',
    'assets/images/introImages/statistics.svg'
  ];

  List<String> nameTitles = [
    '',
    '',
    '',
    '',
  ];

  final List<String> nameSubTitles = List.unmodifiable([
    'Browse your favorite PDF books in Copia',
    'You can upload your own PDF now & enjoy reading',
    'You can Add your favorite Audio along reading books!',
    'Copia will also give you statistical records about your books and how much you read it'
  ]);

  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  double progressPercent = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFFBD5D9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Icon(Icons.book)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () => checkIntro().then((_) =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ControllerScreen()))),
                        child: Text(
                          'Skip',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 550.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) =>
                        setState(() => _currentPage = page),
                    children: _buildListContentPage(),
                  ),
                ),
                _customProgress(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customProgress() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          child: CircleProgressBar(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF7B51D3),
            value: ((_currentPage + 1) * 1.0 / _numPages),
          ),
        ),
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF7B51D3),
          ),
          child: IconButton(
            onPressed: () {
              if (_pageController.page != _numPages - 1) {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              } else {
                checkIntro().then((_) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ControllerScreen())));
              }
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            iconSize: 15,
          ),
        )
      ],
    );
  }

  List<Widget> _buildListContentPage() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(
        _buildMainContent(nameImages[i], nameTitles[i], nameSubTitles[i]),
      );
    }
    return list;
  }

  Padding _buildMainContent(
      String nameImage, String nameTitle, String nameSubTitle) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                nameImage,
                height: 360.0,
                width: 360.0,
              ),
            ),
          ),
          SizedBox(height: 9.0),
          Text(nameTitle, style: kTitleStyle),
          SizedBox(height: 10.0),
          Text(
            nameSubTitle,
            style: kSubtitleStyle,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }

  Future<bool> checkIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('intro', false);
  }
}
