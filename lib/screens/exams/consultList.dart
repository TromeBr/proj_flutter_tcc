import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proj_flutter_tcc/components/SearchBar.dart';
import 'package:proj_flutter_tcc/components/hamburguerMenu.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:proj_flutter_tcc/models/patient.dart';
import 'package:proj_flutter_tcc/models/person.dart';
import 'package:proj_flutter_tcc/screens/exams/consult.dart';
import 'package:proj_flutter_tcc/services/examListService.dart' as examService;
import 'package:proj_flutter_tcc/services/fileServices.dart' as fileService;

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
  final margin = EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0);
  final searchMargin = EdgeInsets.only(right: 10.0, left: 15.0);
  Future<List<MedExam>> exams = examService.getExamesByCpf();
  AnimationController controller;
  bool _showCircle;


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
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBarPattern(
          titleScreen: 'Consulta de Exames',
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
                future.then((examItem) => _examsUpdate(examItem));
              },
            ),
          ],
        ),
        body: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: width,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: searchMargin,
                            alignment: Alignment.topCenter,
                            child: SearchBar(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                (_showCircle
                    ? SizedBox(
                        child: CircularProgressIndicator(
                          value: controller.value,
                          color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                          strokeWidth: 2,
                        ),
                        width: 100,
                        height: 100,
                      )
                    : SizedBox.shrink()),
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
                              snapshot.data?.length == 0) && widget._medExamList.length == 0) {
                            _showCircle = false;
                            return Column(
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                                  size: 100,
                                ),
                                PaddingWidgetPattern(10),
                                Text(
                                  "Nenhum exame cadastrado!",
                                  style: TextStyle(
                                    color: Color(Constants.SYSTEM_PRIMARY_COLOR),
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
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: widget._medExamList.length,
                              itemBuilder: (context, indice) {
                                final exam = widget._medExamList[indice];
                                return ExamItem(exam);
                              },
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: HamburguerMenu());
  }

  void _examsUpdate(MedExam examItem) {
    if (examItem != null) {
      setState(() {
        widget._medExamList.add(examItem);
      });
    }
  }
  void _examsDelete(String idExam) {
     if (idExam != null) {
       var index = widget._medExamList.indexWhere((exam) => exam.id == idExam);
       setState(() {
         widget._medExamList.removeAt(index);
       });
     }
   }
}

class ExamItem extends StatelessWidget {
  final MedExam _exam;

  ExamItem(this._exam);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.assignment_turned_in_sharp,
          color: Colors.white,
        ),
        title:
            Text(_exam.exam.toString(), style: TextStyle(color: Colors.white)),
        subtitle: Text(DateFormat('dd/MM/yyyy').format(_exam.date).toString(),
            style: TextStyle(color: Colors.white)),
        onTap: () async {
          File fileAPI = await fileService.getFile(id: _exam.fileId, lab: _exam.lab);

           if (fileAPI != null) {
             _exam.file = fileAPI;
           }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ExamConsultScreen(_exam);
              },
            ),
          );
        },
      ),
      color: Color(Constants.SYSTEM_PRIMARY_COLOR),
    );
  }


}
