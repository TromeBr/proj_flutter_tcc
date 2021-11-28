import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;

class AboutMedikeepScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutMedikeepState();
  }
}

class AboutMedikeepState extends State<AboutMedikeepScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPattern(
        titleScreen: Constants.ABOUT_SCREEN,
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              //PaddingWidgetPattern(5.0),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  Constants.LOGO_PATH_S1_EX,
                  height: 200,
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
               Container(
                    width: 325,
                  alignment: Alignment.topLeft,
                  child: Text(Constants.ABOUT_TEXT,
                      style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.justify,)
                ),
              Container(
                  width: 325,
                  alignment: Alignment.topLeft,
                  child: Text(Constants.MEMBERS_NAME,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.justify,)
              ),
              Container(
                  width: 325,
                  alignment: Alignment.topLeft,
                  child: Text(Constants.SPECIAL_THANKS,
                    style: TextStyle(fontSize: 20),)
              ),
            ],
          ),
        ),
      );
  }

}
