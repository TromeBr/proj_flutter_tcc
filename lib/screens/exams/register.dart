import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _registerCampo1 = TextEditingController();
  final TextEditingController _registerCampo2 = TextEditingController();
  final TextEditingController _registerCampo3 = TextEditingController();
  final TextEditingController _registerData = TextEditingController();

  //ImagePicker
  PickedFile _image;

  //FilePicker
  String _fileName;
  List<PlatformFile> _paths;
  String _dirPath;
  String _extension;
  bool _loadingPath = false;
  FileType _pickingType = FileType.custom;

 void initState() {
   if(_paths != null)
     _clearCache();
   _image = null;
 }
 Future _getImage(ImageSource source) async{
   try{
     var image = await ImagePicker.platform.pickImage(source: source);
     setState(() {
       _image = image;
     });
   }
   on PlatformException catch (e) {
     print("Operação não suportada: " + e.toString());
   }
   catch (ex) {
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
            PaddingWidgetPattern(4.0),
            TextBoxStandard(
              nameLabel: 'Campo 1',
              controller: _registerCampo1,
            ),
            TextBoxStandard(
              nameLabel: 'Campo 2',
              controller: _registerCampo2,
            ),
            TextBoxStandard(
              nameLabel: 'Campo 3',
              controller: _registerCampo3,
            ),
            TextBoxStandard(
              nameLabel: 'Data',
              controller: _registerData,
              keyboardType: TextInputType.datetime,
            ),
            PaddingWidgetPattern(20.0),
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
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        side: BorderSide(
                          width: 2,
                          color: Colors.black26,
                          style: BorderStyle.solid,
                        ),
                      ),
                      onPressed: () => _openFile(),
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
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        side: BorderSide(
                          width: 2,
                          color: Colors.black26,
                          style: BorderStyle.solid,
                        ),
                      ),
                      onPressed: () => _imagePicker(context),
                    ),
                  ),
                ],
              ),


            PaddingWidgetPattern(30.0),
            Container(
              width: 200.0,
              height: 50.0,
              child: OutlinedButton(
                child: Text('Cadastrar', style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  side: BorderSide(
                    width: 2,
                    color: Colors.black26,
                    style: BorderStyle.solid,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
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
              child:  Wrap(
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
        }
    );
  }

  void _openFile() async {
    setState(() => _loadingPath = true);
    try {
      _dirPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowedExtensions: ['pdf', 'jpeg', 'jpg']
      ))?.files;
    }
    on PlatformException catch (e) {
      print("Operação não suportada: " + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths.first.extension);
      _fileName =
      _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  void _clearCache() {
    FilePicker.platform.clearTemporaryFiles();
  }

}
