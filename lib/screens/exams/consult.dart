import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/SearchBar.dart';
import 'package:proj_flutter_tcc/components/hamburguerMenu.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/login_constants.dart';
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:proj_flutter_tcc/models/patient.dart';
import 'package:proj_flutter_tcc/models/person.dart';

import 'register.dart';

class MedExamConsultScreen extends StatefulWidget {
  final List<MedExam> _medExamList = <MedExam>[];

  @override
  State<StatefulWidget> createState() {
    return MedExamConsultState();
  }
}

class MedExamConsultState extends State<MedExamConsultScreen> {
  final margin = const EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0);
  final searchMargin = const EdgeInsets.only(right: 10.0, left: 15.0);
  final backColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    final pessoaTeste = new Person('Gabriel', 18, '55464654', DateTime.now(), 'Pinda', 'SP', 'Brasil');
    final pacienteTeste = new Patient(pessoaTeste);
    final exameTeste = new MedExam(pacienteTeste, 'Exame Teste', DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    widget._medExamList.clear();
    widget._medExamList.add(exameTeste);
    widget._medExamList.add(exameTeste);
    widget._medExamList.add(exameTeste);
    widget._medExamList.add(exameTeste);
    widget._medExamList.add(exameTeste);
    widget._medExamList.add(exameTeste);
    widget._medExamList.add(exameTeste);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.deepPurple),
          centerTitle: true,
          title: const Text(
            'Consulta de Exames',
            style: TextStyle(color: Colors.deepPurple),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
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
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(5.0), bottom:Radius.circular(5.0) ),
                        border: Border.all(width: 3, color: Colors.deepPurple)),
                    child: Container(
                        child: ListView.builder(
                          itemCount: widget._medExamList.length,
                          itemBuilder: (context, indice) {
                            final exam = widget._medExamList[indice];
                            return ExamItem(exam);
                          },
                        )),
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
        leading: Icon(Icons.assessment_sharp),
        title: Text(_exam.medExamType.toString()),
        subtitle: Text(_exam.medExamDate.toString()),
      ),
    );
  }
}
