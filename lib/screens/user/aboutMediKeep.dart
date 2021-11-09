import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proj_flutter_tcc/components/alertBox.dart';
import 'package:proj_flutter_tcc/components/sharedPreferenceInit.dart';
import 'package:proj_flutter_tcc/components/validators.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:proj_flutter_tcc/services/dataServices.dart' as dataService;

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
                  height: 300,
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      );
  }

}
