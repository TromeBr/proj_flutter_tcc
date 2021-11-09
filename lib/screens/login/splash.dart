import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/sharedPreferenceInit.dart';
import 'package:proj_flutter_tcc/screens/exams/consultList.dart';
import 'login.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Splash();
  }
}

class Splash extends State<SplashScreen> {
  Image myImage;

  @override
  void initState() {
    super.initState();
    myImage = Image.asset(
      Constants.LOGO_PATH_S1_P,
      height: 200,
      width: 250,
    );
    _navigateToContextScreen();
  }

  void _navigateToContextScreen() async {
    var firstTime = await _getUserContext(context);
    if (firstTime) {
      await Future.delayed(Duration(milliseconds: 1500), () {});
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      await Future.delayed(Duration(milliseconds: 1500), () {});
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MedExamConsultScreen()));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(myImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            myImage,
              Container(
                child: Text(
                  Constants.MEDIKEEP,
                  style: TextStyle(
                    fontFamily: 'Syncopate',
                    color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

Future<bool> _getUserContext(BuildContext context) async {
  bool _firstTime = await initializeApp();
  return _firstTime;
}
