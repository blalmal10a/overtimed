import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overtimed/controllers/employee_sheet/employee_sheet_controller.dart';
import '/helpers/storage_helper.dart';

Rx<TextEditingController> adminEmail =
    TextEditingController(text: 'malsawma7777@gmail.com').obs;
Rx<TextEditingController> adminPassword =
    TextEditingController(text: 'arpuisente').obs;

Future<void> adminLogin() async {
  try {
    final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: adminEmail.value.text, password: adminPassword.value.text);
//save admin credentials
    localStorage.setString(
        'idToken', await credentials.user!.getIdToken() ?? '');
    localStorage.setString(
        'refreshToken', await credentials.user!.refreshToken ?? '');
    localStorage.setString('localId', credentials.user!.uid);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}
