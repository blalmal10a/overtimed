import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:overtimed/helpers/authentication_helper.dart';
import 'package:overtimed/views/authenticated_view.dart';

import '/controllers/user_authentication.dart';
import '/views/unauthenticated_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebasedata = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  await authenticateUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          is_authenticated.value ? AuthenticatedView() : UnauthenticatedView(),
    );
  }
}
