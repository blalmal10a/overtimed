import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('PAGE NOT FOUND'),
            TextButton(
              onPressed: () => {},
              child: Text('Go to home page'),
            )
          ],
        ),
      ),
    );
  }
}
