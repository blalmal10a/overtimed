import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:tilte/controllers/user_authentication.dart';
import 'package:tilte/views/unauthenticated_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebasedata = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  if (firebasedata == 1) {
    await authenticateUser();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UnauthenticatedView(),
    );
  }
}
