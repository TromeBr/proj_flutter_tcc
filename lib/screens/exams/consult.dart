import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:proj_flutter_tcc/components/PDFViewer.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:path/path.dart' as fileExtension;
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proj_flutter_tcc/services/fileServices.dart' as fileService;

class ExamConsultScreen extends StatefulWidget {
  ExamConsultForm state;
  MedExam exam;

  ExamConsultScreen(this.exam);

  @override
  State<StatefulWidget> createState() {
    var state = ExamConsultForm(this.exam);
    this.state = state;
    return state;
  }
}

class ExamConsultForm extends State<ExamConsultScreen> {
  String _id;
  final TextEditingController _registerExam = TextEditingController();
  final TextEditingController _registerDoc = TextEditingController();
  final TextEditingController _registerLab = TextEditingController();
  final TextEditingController _registerData = TextEditingController();
  var maskDate = new MaskTextInputFormatter(mask: '##/##/####');
  MedExam exam;
  PDFViewController PDFController;
  int pages = 0;
  int indexPage = 0;

  ExamConsultForm(this.exam) {
     _id = exam.id;
    _registerExam.text = exam.exam;
    _registerDoc.text = exam.requestingPhysician["nome"];
    _registerLab.text = exam.lab;
    _registerData.text = DateFormat('dd/MM/yyyy').format(exam.date).toString();
  }

  // @override
  // Future<void> initState() async {
  //   File fileAPI = await fileService.getFile(id: _id);
  //   setState(() {
  //     if(fileAPI != null){
  //       exam.file = fileAPI;
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPattern(titleScreen: 'Exame'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextBoxStandard(
              nameLabel: 'Tipo',
              controller: _registerExam,
              readOnly: true,
            ),
            TextBoxStandard(
              nameLabel: 'Médico Solicitante',
              controller: _registerDoc,
              readOnly: true,
            ),
            TextBoxStandard(
              nameLabel: 'Laboratório',
              controller: _registerLab,
              readOnly: true,
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
            if (exam.file != null)
              Column(
                children: [
                  PaddingWidgetPattern(10),
                  Container(
                    child: fileExtension.extension(exam.file.path) != '.pdf'
                        ? FullScreenWidget(
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
                        : Container(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PDFViewer(exam.file)),
                                );
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    Constants.GENERIC_PDF_PATH,
                                    alignment: Alignment.center,
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  Flexible(
                                    child: Container(
                                      width: 70,
                                      child: Text(
                                        fileExtension.basenameWithoutExtension(
                                            exam.file.path),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    width: 150,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
