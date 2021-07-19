import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:proj_flutter_tcc/models/consts.dart';
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ExamRegisterScreen extends StatefulWidget {
  ExamRegisterForm state;

  @override
  State<StatefulWidget> createState() {
    var state = ExamRegisterForm();
    this.state = state;
    return state;
  }
}

class ExamRegisterForm extends State<ExamRegisterScreen> {
  final TextEditingController _registerExam = TextEditingController();
  final TextEditingController _registerDoc = TextEditingController();
  final TextEditingController _registerLab = TextEditingController();
  final TextEditingController _registerData = TextEditingController();
  var maskDate = new MaskTextInputFormatter(mask: '##/##/####');

  //ImagePicker
  PickedFile _image;
  File imageFile;

  //FilePicker
  String _fileName;
  List<PlatformFile> _paths;
  String fileExtension;
  File filePath;
  bool _loadingPath = false;
  FileType _pickingType = FileType.custom;

  void initState() {
    if (_paths != null) _clearCache();
    _image = null;
    imageFile = null;
    filePath = null;
    DateTime now = DateTime.now();
    _registerData.text = DateFormat('dd/MM/yyyy').format(now).toString();
  }

  Future _getImage(ImageSource source) async {
    try {
      var image = await ImagePicker.platform.pickImage(source: source);
      setState(() {
        _image = image;
      });
      if (_image != null) {
        imageFile = File(_image.path);
      }
    } on PlatformException catch (e) {
      print("Operação não suportada: " + e.toString());
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    //var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBarPattern(titleScreen: 'Cadastro de Exames'),
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
                inputFormatters: [maskDate],
                controller: _registerData,
                style: TextStyle(fontSize: 24.0),
                decoration: InputDecoration(
                    labelText: 'data',
                    suffix: InkWell(
                        onTap: () => _selectDate(context),
                        child: Icon(Icons.calendar_today, color: Color(systemPrimaryColor),))),
              ),
            ),
            PaddingWidgetPattern(10.0),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 83, 0),
                ),
                Container(
                  width: 100.0,
                  height: 50.0,
                  child: OutlinedButton(
                    child: Icon(
                      Icons.attach_file_sharp,
                      color: Colors.white,
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: imageFile == null && filePath == null
                          ? Color(systemPrimaryColor)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      side: BorderSide(
                        width: 2,
                        color: Colors.white,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: imageFile == null && filePath == null
                        ? () async => _openFile()
                        : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                ),
                Container(
                  width: 100.0,
                  height: 50.0,
                  child: OutlinedButton(
                    child: Icon(
                      Icons.photo_camera_sharp,
                      color: Colors.white,
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: imageFile == null && filePath == null
                          ? Color(systemPrimaryColor)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      side: BorderSide(
                        width: 2,
                        color: Colors.white,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed: imageFile == null && filePath == null
                        ? () async => _imagePicker(context)
                        : null,
                  ),
                ),
              ],
            ),
            Container(
                child: imageFile == null && filePath == null
                    ? null
                    : Column(
                        children: [
                          PaddingWidgetPattern(10.0),
                          Container(
                            width: 300.0,
                            height: 100.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (imageFile != null
                                    ? Image.file(
                                        imageFile,
                                        alignment: Alignment.center,
                                        fit: BoxFit.scaleDown,
                                      )
                                    : getTypedImage(filePath, fileExtension)),
                                Flexible(
                                  child:
                                      filePath != null && fileExtension == 'pdf'
                                          ? Container(
                                              width: 70,
                                              child: Text(
                                                _fileName,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : Text(''),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                ),
                                FloatingActionButton(
                                  child: Icon(Icons.close_sharp),
                                  backgroundColor: Color(systemPrimaryColor),
                                  foregroundColor: Colors.white,
                                  mini: true,
                                  tooltip: 'Deletar ' +
                                      (imageFile == null
                                          ? 'Arquivo'
                                          : 'Imagem'),
                                  onPressed: () {
                                    setState(() {
                                      initState();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
            (imageFile == null && filePath == null
                ? PaddingWidgetPattern(30.0)
                : PaddingWidgetPattern(5.0)),
            Container(
              width: 200.0,
              height: 50.0,
              child: OutlinedButton(
                child: Text('Cadastrar', style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(systemPrimaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  side: BorderSide(
                    width: 2,
                    color: Colors.white,
                    style: BorderStyle.solid,
                  ),
                ),
                onPressed: () {
                  _CreateExam(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _imagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeria'),
                      onTap: () {
                        _getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openFile() async {
    setState(() => _loadingPath = true);
    try {
      _paths = (await FilePicker.platform.pickFiles(
              type: _pickingType, allowedExtensions: ['pdf', 'jpeg', 'jpg']))
          ?.files;
    } on PlatformException catch (e) {
      print("Operação não suportada: " + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths.first.extension);
      filePath = File(_paths.first.path);
      fileExtension = _paths.first.extension;
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  void _clearCache() {
    FilePicker.platform.clearTemporaryFiles();
  }

  Image getTypedImage(File fileImage, String fileExtension) {
    if (fileExtension == 'pdf') {
      return Image.asset(
        GENERICPDFPATH,
        alignment: Alignment.center,
        width: 75,
        height: 75,
        fit: BoxFit.scaleDown,
      );
    } else {
      return Image.file(
        fileImage,
        alignment: Alignment.center,
        fit: BoxFit.scaleDown,
      );
    }
  }

  Widget _CreateExam(BuildContext context) {
    List<String> _camposAlert = [];
    final String exam = _registerExam.text;
    final String doctorName = _registerDoc.text;
    final String labName = _registerLab.text;
    final DateTime date = DateTime.parse(_registerData.text != ''
        ? _registerData.text.split('/').reversed.join('')
        : '1900/01/01');

    if (exam.isEmpty) {
      _camposAlert.add('Exame');
    }
    if (doctorName.isEmpty) {
      _camposAlert.add('Médico Solicitante');
    }
    if (labName.isEmpty) {
      _camposAlert.add('Laboratório');
    }
    if (DateFormat('yyyy-MM-dd').format(date).toString() == '1900-01-01') {
      _camposAlert.add('Data');
    }

    if (_camposAlert.isEmpty) {
      final createdExam = MedExam(exam, date);
      Navigator.pop(context, createdExam);
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Campo não Preenchido'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  for (var campo in _camposAlert) Text('Campo: ' + campo),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  _selectDate(BuildContext context) async {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day)
    ).then((date) {
      setState(() {
        _registerData.text = DateFormat('dd/MM/yyyy').format(date).toString();
      });
    });
  }
}
