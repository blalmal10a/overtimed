import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dummySheetLink =
    'https://docs.google.com/spreadsheets/d/1jevwdVSTkuXrLuTHPARKdOoiHo4FNszRToXUUskPhiw/edit#gid=1644393544';
late SharedPreferences localStorage;
Rx<TextEditingController> sheetLink = TextEditingController(text: '').obs;
void initStorage() async {
  try {
    localStorage = await SharedPreferences.getInstance();
    print(localStorage);
  } catch (e) {
    print(e);
  }
}
