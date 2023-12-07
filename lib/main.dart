import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:overtimed/controllers/employee_sheet/employee_sheet_controller.dart';
import 'package:overtimed/controllers/user_authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/helpers/authentication_helper.dart';
import '/views/modules/authenticated_view.dart';
import '/views/modules/unauthenticated_view.dart';
import 'helpers/firebase/firebase_options.dart';
import 'helpers/storage_helper.dart';

void main() async {
  localStorage = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();

  final firebasedata = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  try {
    await authenticateUser();
    getEmployees();
    is_authenticated.value = true;
  } catch (e) {
    //
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Obx(
        () => is_authenticated.value
            ? AuthenticatedView()
            : UnauthenticatedView(),
      ),
    );
  }
}
