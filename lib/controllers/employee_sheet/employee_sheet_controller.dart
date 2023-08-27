import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:overtimed/controllers/file_controller.dart';
import 'package:overtimed/helpers/storage_helper.dart';

RxList<dynamic> employeeList = [].obs;
RxMap selectedEmployee = {}.obs;

Future<void> submitUserSheet(String? id, String? link) async {
  print('id is $id');
  print('link is $link');
}

Future<void> getEmployees() async {
  final db = FirebaseFirestore.instance;

  final employees = db.collection("employees");
  final querySnapshot = await employees.get();

  employeeList.value = querySnapshot.docs;
  for (var doc in querySnapshot.docs) {
    // print('${doc.id} => ${doc.data()}, ${doc.data().runtimeType}');
  }
}

Future<void> updateEmployee() async {
  final url = sheetLink.value.text;
  var sheetId = '';
  selectedEmployee['sheet_link'] = url;
  try {
    sheetId = getFileIdFromUrl(url);
  } catch (e) {}
  selectedEmployee['sheetId'] = sheetId;
  final db = FirebaseFirestore.instance;
  final batch = db.batch();

  var employeeRef = db.collection("employees").doc(selectedEmployee['email']);
  batch.set(employeeRef, selectedEmployee.value);
  await batch.commit();
  // print('update done');
}
