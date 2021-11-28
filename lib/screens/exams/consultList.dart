import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:proj_flutter_tcc/components/hamburguerMenu.dart';
import 'package:proj_flutter_tcc/components/sharedPreferenceInit.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:proj_flutter_tcc/screens/exams/consult.dart';
import 'package:proj_flutter_tcc/services/examListService.dart' as examService;

import 'register.dart';

class MedExamConsultScreen extends StatefulWidget {
  List<MedExam> _medExamList = <MedExam>[];

  @override
  State<StatefulWidget> createState() {
    return MedExamConsultState();
  }
}

class MedExamConsultState extends State<MedExamConsultScreen>
    with TickerProviderStateMixin {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final margin = EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0);
  Future<List<MedExam>> exams = examService.getExamesByCpf();
  AnimationController controller;
  bool _showCircle;

  String name = 'Teste';

  @override
  void initState() {
    _showCircle = widget._medExamList.isEmpty;
    if (widget._medExamList.isNotEmpty) widget._medExamList.clear();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    getUsername(context);
    super.initState();
  }
  @override
  Future<void> didChangeDependencies() async {
    var _user = await initializePreference();
    if (_user != null) {
      Map<String, dynamic> decoded = jsonDecode(_user);
      if (this.name != UserContext.fromJson(decoded).name)
        this.name = UserContext.fromJson(decoded).name;
    }
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBarPattern(
              titleScreen: '',
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final Future<MedExam> future = Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ExamRegisterScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        Constants.LOGO_PATH_S1_EX,
                        height: 100,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                    PaddingWidgetPattern(5),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Olá, ',
                            style: TextStyle(
                              fontFamily: 'Syncopate',
                              color: Colors.blueGrey,
                              fontSize: 23,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            name,
                            style: TextStyle(
                              fontFamily: 'Syncopate',
                              color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PaddingWidgetPattern(10),
                    (_showCircle
                        ? Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: SizedBox(
                              child: CircularProgressIndicator(
                                value: controller.value,
                                color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                                strokeWidth: 2,
                              ),
                              width: 100,
                              height: 100,
                            ),
                        )
                        : SizedBox.shrink()),
                    PaddingWidgetPattern(10),
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: width,
                        margin: margin,
                        child: FutureBuilder<List<MedExam>>(
                            future: exams,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<MedExam>> snapshot) {
                              if (snapshot.data != null &&
                                  snapshot.data.length >
                                      widget._medExamList.length) {
                                widget._medExamList.addAll(snapshot.data);
                                _showCircle = false;
                              } else if ((snapshot.hasError ||
                                      snapshot.data?.length == 0) &&
                                  widget._medExamList.length == 0) {
                                _showCircle = false;
                                return Column(
                                  children: [
                                    Icon(
                                      Icons.assignment_outlined,
                                      color:
                                          Color(Constants.SYSTEM_PRIMARY_COLOR),
                                      size: 100,
                                    ),
                                    PaddingWidgetPattern(10),
                                    Text(
                                      "Nenhum exame cadastrado!",
                                      style: TextStyle(
                                        color:
                                            Color(Constants.SYSTEM_PRIMARY_COLOR),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                );
                              }
                              return Scrollbar(
                                isAlwaysShown: false,
                                child: RefreshIndicator(
                                  color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                                  key: refreshKey,
                                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                                  onRefresh: refreshList,
                                   strokeWidth: 3,
                                  displacement: 100,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                    itemCount: widget._medExamList.length,
                                    itemBuilder: (context, indice) {
                                      final exam = widget._medExamList[indice];
                                      return ExamItem(exam);
                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            drawer: HamburguerMenu()),
      );
  }


  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    exams = examService.getExamesByCpf();
  }

  Future<void> getUsername(BuildContext context) async {
    var _user = await initializePreference();
    if (_user != null) {
      Map<String, dynamic> decoded = jsonDecode(_user);
      setState(() {
        this.name = UserContext.fromJson(decoded).name;
      });
    }
  }
}

class ExamItem extends StatefulWidget {
  final MedExam _exam;

  ExamItem(this._exam);

  @override
  State<StatefulWidget> createState() {
    return ExamItemState();
  }
}
class ExamItemState extends State<ExamItem>{

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          trailing: widget._exam.lab != null ? Icon(
            Icons.add_business_sharp,
            color: Colors.white,
          ) : null,
          leading: Icon(
            Icons.assignment_outlined,
            color: Colors.white,
          ),
          title:
          Text(widget._exam.exam.toString(), style: TextStyle(color: Colors.white)),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(widget._exam.date).toString(),
              style: TextStyle(color: Colors.white)),

          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ExamConsultScreen(widget._exam);
                },
              ),
            );
          },
        ),
        color: Color(Constants.SYSTEM_PRIMARY_COLOR),
      );
  }

}


