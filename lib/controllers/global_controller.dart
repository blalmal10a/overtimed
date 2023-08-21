import 'package:flutter/material.dart';

void showToast(BuildContext context, String toastMessage) {
  final scaffold = ScaffoldMessenger.of(context);

  scaffold.showSnackBar(
    SnackBar(
      content: Text(toastMessage),
      action: SnackBarAction(
          label: 'Hide', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}
