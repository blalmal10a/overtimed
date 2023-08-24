import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences localStorage;

void initStorage() async {
  try {
    localStorage = await SharedPreferences.getInstance();
    print(localStorage);
  } catch (e) {
    print(e);
  }
}
