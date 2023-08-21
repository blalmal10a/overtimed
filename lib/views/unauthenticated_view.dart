import 'package:flutter/material.dart';
import '/controllers/user_authentication.dart';

class UnauthenticatedView extends StatelessWidget {
  const UnauthenticatedView({super.key});

  @override
  Widget build(BuildContext context) {
    handleAuthentiation() {
      authenticateUser();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Project overtime record'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () => handleAuthentiation(),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text('Sign in with GOOGLE'),
            )),
      ),
    );
  }
}
