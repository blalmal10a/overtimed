import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:overtimed/helpers/storage_helper.dart';

final Rx<TextEditingController> overtimeProjectName =
    TextEditingController(text: '').obs;

final Rx<String?> documentId = ''.obs;
final Rx<DateTime?> startTime = DateTime.now().subtract(Duration(hours: 1)).obs;
final Rx<DateTime?> endTime = DateTime.now().obs;
final Rx<String?> projectName = ''.obs;

Future<void> onConfirmDelete() async {
  print(documentId.value);
  final db = FirebaseFirestore.instance;
  final collectionName = localStorage.getString('collection-name') ?? 'trash';

  final docReferece = db.collection(collectionName).doc(documentId.value);
  docReferece.delete();
}
