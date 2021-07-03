import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/SearchBar.dart';
import 'package:proj_flutter_tcc/components/hamburguerMenu.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:proj_flutter_tcc/models/patient.dart';
import 'package:proj_flutter_tcc/models/person.dart';
import 'package:proj_flutter_tcc/services/examListService.dart' as examService;

import 'register.dart';

class MedExamConsultScreen extends StatefulWidget {
  final List<MedExam> _medExamList = <MedExam>[];

  @override
  State<StatefulWidget> createState() {
    return MedExamConsultState();
  }
}

class MedExamConsultState extends State<MedExamConsultScreen> {
  final margin = EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0);
  final searchMargin = EdgeInsets.only(right: 10.0, left: 15.0);
  final backColor = Colors.deepPurple;
  Future<List<MedExam>> exams = examService.getExamesByCpf('50009379029');

  @override
  Widget build(BuildContext context) {
    final pessoaTeste = new Person(
        'Gabriel', 18, '50009379029', DateTime.now(), 'Pinda', 'SP', 'Brasil');
    final pacienteTeste = new Patient(pessoaTeste);
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
                Expanded(
                  flex: 3,
                  child: Container(
                    width: width,
                    margin: margin,
                    child: FutureBuilder<List<MedExam>>(
                        future: exams,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<List<MedExam>> snapshot
                        ) {
                          if (snapshot.data != null)
                            widget._medExamList.addAll(snapshot.data);
                          return Scrollbar(
                            isAlwaysShown: true,
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
}

class ExamItem extends StatelessWidget {
  final MedExam _exam;

  ExamItem(this._exam);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          _exam.medExamType == 'Sangue' || _exam.medExamType == 'Pézinho'
              ? Icons.accessibility_new_sharp
              : Icons.assignment_turned_in_sharp,
          color: Colors.white,
        ),
        title: Text(_exam.medExamType.toString(),
            style: TextStyle(color: Colors.white)),
        subtitle: Text(_exam.medExamDate.toString(),
            style: TextStyle(color: Colors.white)),
      ),
      color: Colors.deepPurple,
    );
  }
}
