import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:overtimed/helpers/authentication_helper.dart';
import '/views/modules/authenticated_view.dart';
import '/views/modules/unauthenticated_view.dart';
import 'helpers/firebase/firebase_options.dart';
import 'helpers/storage_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initStorage();
  final firebasedata = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  try {
    // await authenticateUser();
  } catch (e) {}
  is_authenticated.value = true;

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
