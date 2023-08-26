import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

RxList<dynamic> employeeList = [].obs;

Future<void> submitUserSheet(String? id, String? link) async {
  print('id is $id');
  print('link is $link');
}

Future<void> getEmployees() async {
  final db = FirebaseFirestore.instance;

  final employees = db.collection("employees");
  final querySnapshot = await employees.get();
  print('data is $querySnapshot');
  employeeList.value = querySnapshot.docs;
  for (var doc in querySnapshot.docs) {
    print('${doc.id} => ${doc.data()}, ${doc.data().runtimeType}');
  }
}
