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
import 'package:proj_flutter_tcc/services/examService.dart' as examService;
import 'package:share/share.dart';


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
  final TextEditingController _registerCRM = TextEditingController();
  final TextEditingController _registerData = TextEditingController();
  var maskDate = new MaskTextInputFormatter(mask: '##/##/####');
  MedExam exam;
  String _value;

  PDFViewController PDFController;
  int pages = 0;
  int indexPage = 0;

  ExamConsultForm(this.exam) {
    _id = exam.id;
    _registerExam.text = exam.exam;
    _registerDoc.text = exam.requestingPhysician != null
        ? exam.requestingPhysician["nome"]
        : "";
    _registerCRM.text = exam.requestingPhysician != null
        ? exam.requestingPhysician['crm'].toString()
        : "";
    _value = exam.requestingPhysician != null
    ? exam.requestingPhysician['uf']
        : "00";
    _registerData.text = DateFormat('dd/MM/yyyy').format(exam.date).toString();
  }

  get fileApi => fileService
      .getFile(id: exam.fileId, lab: exam.lab)
      .then((value) => exam.file = value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPattern(
        titleScreen: 'Exame',
        actions: this.exam.lab == null
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.delete_outline_sharp),
                  onPressed: () async {
                    var _ExamDelete =
                        await examService.deleteExam(this.exam.id);
                    if (_ExamDelete)
                      _deleteResult("Remoção Concluída",
                          "O exame foi deletado com sucesso",
                          idExam: this.exam.id);
                    else
                      _deleteResult(
                          "Erro ao deletar", "Por favor, tente mais tarde");
                  },
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextBoxStandard(
              nameLabel: 'Tipo',
              controller: _registerExam,
              readOnly: true,
            ),
            TextBoxStandard(
              nameLabel: 'CRM',
              controller: _registerCRM,
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            IgnorePointer(
              ignoring: true,
              child: Container(
                  margin: EdgeInsets.only(top: 20.0, left: 20.0),
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        'UF:',
                        style: TextStyle(fontSize: 24),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton<String>(
                          style: TextStyle(fontSize: 24, color: Colors.black),
                          iconSize: 0,
                          elevation: 16,
                          hint: Text("UF"),
                          value: _value,
                          autofocus: true,
                          items: Constants.ESTADOS.entries
                              .map<DropdownMenuItem<String>>((entry) {
                            return new DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  )),
            ),
            TextBoxStandard(
              nameLabel: 'Médico Solicitante',
              controller: _registerDoc,
              readOnly: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: TextFormField(
                readOnly: true,
                inputFormatters: [maskDate],
                controller: _registerData,
                style: TextStyle(fontSize: 24.0),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(Constants.SYSTEM_PRIMARY_COLOR)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(Constants.SYSTEM_PRIMARY_COLOR)),
                  ),
                  labelStyle: TextStyle(color: Colors.black, fontSize: 23),
                  labelText: 'Data',
                  //labelStyle: TextStyle(color: Color(systemPrimaryColor))
                ),
              ),
            ),
            PaddingWidgetPattern(25),
            FutureBuilder<File>(
                  future: fileApi,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaddingWidgetPattern(10),
                          Container(
                            child: fileExtension.extension(exam.file.path) !=
                                    '.pdf'
                                ? FullScreenWidget(
                                    child: Center(
                                      child: Hero(
                                        tag: "smallImage",
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
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
                                                fileExtension
                                                    .basenameWithoutExtension(
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
                          PaddingWidgetPattern(10),
                          FloatingActionButton(
                            child: Icon(Icons.share_outlined),
                            backgroundColor:
                                Color(Constants.SYSTEM_PRIMARY_COLOR),
                            foregroundColor: Colors.white,
                            mini: true,
                            tooltip: 'Compartilhar ' +
                                (fileExtension.extension(exam.file.path) ==
                                        '.pdf'
                                    ? 'Arquivo'
                                    : 'Imagem'),
                            onPressed: () => _shareFile(exam.file.path),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                          child: SizedBox(
                        child: CircularProgressIndicator(
                          color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                          strokeWidth: 2,
                        ),
                        width: 50,
                        height: 50,
                      ));
                    }
                  }
                  ),
          ],
        ),
      ),
    );
  }

  void _deleteResult(String messageTitle, String message, {String idExam}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(messageTitle),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).restorablePopAndPushNamed('/consultList');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _shareFile(String filePath) async {
    List<String> fileList = [];
    if (filePath.isNotEmpty) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      fileList.add(filePath);
      await Share.shareFiles(fileList,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
    fileList.clear();
  }
}
