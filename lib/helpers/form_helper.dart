import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

final Rx<TextEditingController> overtimeProjectName =
    TextEditingController(text: '').obs;

final Rx<String?> documentId = ''.obs;
final Rx<DateTime?> startTime = DateTime.now().subtract(Duration(hours: 1)).obs;
final Rx<DateTime?> endTime = DateTime.now().obs;
final Rx<String?> projectName = ''.obs;

Future<void> onConfirmDelete() async {
  print(documentId.value);
}
