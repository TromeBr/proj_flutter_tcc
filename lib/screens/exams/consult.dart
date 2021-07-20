import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:path/path.dart' as fileExtension;
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class ExamConsultScreen extends StatefulWidget {
  ExamConsultForm state;
  final MedExam exam;

  ExamConsultScreen(this.exam);

  @override
  State<StatefulWidget> createState() {
    var state = ExamConsultForm(this.exam);
    this.state = state;
    return state;
  }
}

class ExamConsultForm extends State<ExamConsultScreen> {
  final TextEditingController _registerExam = TextEditingController();
  final TextEditingController _registerDoc = TextEditingController();
  final TextEditingController _registerLab = TextEditingController();
  final TextEditingController _registerData = TextEditingController();
  var maskDate = new MaskTextInputFormatter(mask: '##/##/####');
  final MedExam exam;

  ExamConsultForm(this.exam) {
    _registerExam.text = exam.exam;
    _registerDoc.text = exam.exam;
    _registerLab.text = exam.exam;
    _registerData.text = DateFormat('dd/MM/yyyy').format(exam.date).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPattern(titleScreen: 'Exame de ' + exam.exam),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextBoxStandard(
              nameLabel: 'Exame',
              controller: _registerExam,
            ),
            TextBoxStandard(
              nameLabel: 'Médico Solicitante',
              controller: _registerDoc,
            ),
            TextBoxStandard(
              nameLabel: 'Laboratório',
              controller: _registerLab,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                readOnly: true,
                inputFormatters: [maskDate],
                controller: _registerData,
                style: TextStyle(fontSize: 24.0),
                decoration: InputDecoration(
                  labelText: 'Data',
                  //labelStyle: TextStyle(color: Color(systemPrimaryColor))
                ),
              ),
            ),
            if(exam.file != null)
              Container(
                child: fileExtension.extension(exam.file.path) != '.pdf' ?
                FullScreenWidget(
                  child: Center(
                    child: Hero(
                      tag: "smallImage",
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          exam.file,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
                :
                Text('PDF_AQUI'),
                width: 150,
              ),
          ],
        ),
      ),
    );
  }
}
