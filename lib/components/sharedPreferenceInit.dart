import 'package:shared_preferences/shared_preferences.dart';

Future<String> initializePreference() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String result = prefs?.getString("userContext");
  return result;
}



