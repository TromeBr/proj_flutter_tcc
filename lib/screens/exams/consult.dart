import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/hamburguerMenu.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/login_constants.dart';
import 'package:proj_flutter_tcc/models/medExam.dart';

import 'register.dart';

class MedExamConsultScreen extends StatefulWidget {
  final List<MedExam> _medExamList = <MedExam>[];

  @override
  State<StatefulWidget> createState() {
    return MedExamConsultState();
  }
}

class MedExamConsultState extends State<MedExamConsultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView.builder(
          itemCount: widget._medExamList.length,
          itemBuilder: (context, indice) {
            final exam = widget._medExamList[indice];
            return ExamItem(exam);
          },
        ),

      drawer: HamburguerMenu()
    );
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
