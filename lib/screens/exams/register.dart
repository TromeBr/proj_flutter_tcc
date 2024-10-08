import 'dart:io';

import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proj_flutter_tcc/services/examService.dart' as examService;

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
  final TextEditingController _registerCRM = TextEditingController();
  final TextEditingController _registerDoc = TextEditingController();
  final TextEditingController _registerData = TextEditingController();
  var maskDate = new MaskTextInputFormatter(mask: '##/##/####');
  bool _isLoading = false;
  bool _selected;
  bool _searchButtonVerify = false;

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

  String _value = '00';

  void initState() {
    clearCache();
    _isLoading = false;
    _selected = false;
    DateTime now = DateTime.now();
    context != null
        ? _registerData.text = DateFormat('dd/MM/yyyy').format(now).toString()
        : null;
  }

  void clearCache() {
    if (_paths != null) _clearCache();
    _image = null;
    imageFile = null;
    filePath = null;
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
    return IgnorePointer(
      ignoring: _selected,
      child: Scaffold(
        appBar: AppBarPattern(titleScreen: 'Cadastro de Exame'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextBoxStandard(
                nameLabel: 'Tipo',
                controller: _registerExam,
              ),
              TextBoxStandard(
                nameLabel: 'CRM',
                controller: _registerCRM,
                keyboardType: TextInputType.number,
                onChange: enableButton,
              ),
              Container(
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
                          iconSize: 24,
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
                          onChanged: (String val) {
                            setState(() {
                              _value = val;
                            });
                            enableButton('');
                          },
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.only(top: 10.0, left: 20.0),
                alignment: Alignment.topLeft,
                child: FloatingActionButton(
                  heroTag: "btnFind",
                  child: Icon(Icons.person_search_sharp),
                  backgroundColor: _searchButtonVerify
                      ? Color(Constants.SYSTEM_PRIMARY_COLOR)
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  //mini: true,
                  tooltip: 'Pesquisar ',
                  onPressed: _searchButtonVerify ? () => _docPick() : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                child: TextField(
                  readOnly: true,
                  controller: _registerDoc,
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
                    labelText: 'Médico Solicitante',
                  ),
                ),
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
                      suffix: InkWell(
                          onTap: () => _selectDate(context),
                          child: Icon(
                            Icons.calendar_today,
                            color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                          ))),
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
                            ? Color(Constants.SYSTEM_PRIMARY_COLOR)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
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
                            ? Color(Constants.SYSTEM_PRIMARY_COLOR)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
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
                                      ? FullScreenWidget(
                                          child: Center(
                                            child: Hero(
                                              tag: "smallImage",
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Image.file(
                                                  imageFile,
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                          ),
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
                                    heroTag: "btnDel",
                                    child: Icon(Icons.close_sharp),
                                    backgroundColor:
                                        Color(Constants.SYSTEM_PRIMARY_COLOR),
                                    foregroundColor: Colors.white,
                                    mini: true,
                                    tooltip: 'Deletar ' +
                                        (imageFile == null
                                            ? 'Arquivo'
                                            : 'Imagem'),
                                    onPressed: () {
                                      setState(() {
                                        clearCache();
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
                  : PaddingWidgetPattern(15.0)),
              _isLoading
                  ? Center(
                      child: SizedBox(
                      child: CircularProgressIndicator(
                        color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                        strokeWidth: 2,
                      ),
                      width: 50,
                      height: 50,
                    ))
                  : Container(
                      width: 200.0,
                      height: 50.0,
                      child: OutlinedButton(
                        child: Text('Cadastrar',
                            style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Color(Constants.SYSTEM_PRIMARY_COLOR),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _selected = true;
                          });
                          _CreateExam(context);
                        },
                      ),
                    ),
              PaddingWidgetPattern(10.0)
            ],
          ),
        ),
      ),
    );
  }

  void enableButton(String _) {
    if (_registerCRM.text.isNotEmpty && _value != '00') {
      setState(() {
        _searchButtonVerify = true;
      });
    } else {
      setState(() {
        _searchButtonVerify = false;
      });
    }
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

  Future<void> _docPick() async {
    if (_registerCRM.text.isNotEmpty && _value != '00') {
      var docName = await examService.getDoctor(_registerCRM.text, _value);
      if(docName.isNotEmpty){
        setState(() {
          _registerDoc.text = docName;
        });
      }
      else{
        _registerDoc.text = '';
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Médico não encontrado'),
              content: Text('Por favor, tente outra indentificação'),
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
        Constants.GENERIC_PDF_PATH,
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

  Future<Widget> _CreateExam(BuildContext context) async {
    List<String> _camposAlert = [];
    final String exam = _registerExam.text;
    final String doctorName = _registerDoc.text;
    final String crmNumber = _registerCRM.text;
    final DateTime date = DateTime.parse(_registerData.text != ''
        ? _registerData.text.split('/').reversed.join('')
        : '1900/01/01');
    final File fileRegister = filePath != null
        ? filePath
        : imageFile != null
            ? imageFile
            : null;

    if (exam.isEmpty) {
      _camposAlert.add('Tipo');
    }
    if (crmNumber.isEmpty) {
      _camposAlert.add('CRM');
    }
    if (_value == '00') {
      _camposAlert.add('UF');
    }
    if (doctorName.isEmpty) {
      _camposAlert.add('Médico Solicitante');
    }
    if (DateFormat('yyyy-MM-dd').format(date).toString() == '1900-01-01') {
      _camposAlert.add('Data');
    }
    if (fileRegister == null) {
      _camposAlert.add('Arquivo');
    }

    if (_camposAlert.isEmpty) {
      Map<String, dynamic> doctorAttribute = {'nome': doctorName,'crm': crmNumber, 'uf': _value};
      MedExam createdExam = MedExam(
        exam,
        date,
        file: fileRegister, requestingPhysician: doctorAttribute
      );
      var ExamInsert = await examService.insertExam(createdExam);
      if (ExamInsert != null) {
        Navigator.of(context).restorablePopAndPushNamed('/consultList');
      } else {
        setState(() {
          _isLoading = false;
          _selected = false;
        });
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro ao inserir o exame'),
              content: const Text('Tente novamente mais tarde'),
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
    } else {
      setState(() {
        _isLoading = false;
        _selected = false;
      });
      showDialog<void>(
        context: context,
        barrierDismissible: false,
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
            initialDate: DateTime.now().add(Duration(hours: -3)),
            firstDate: DateTime(1900),
            lastDate: DateTime.utc(
                DateTime.now().year, DateTime.now().month, DateTime.now().day))
        .then((date) {
      setState(() {
        _registerData.text = DateFormat('dd/MM/yyyy').format(date).toString();
      });
    });
  }
}
