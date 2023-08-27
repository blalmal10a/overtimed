import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/employee_sheet/employee_sheet_controller.dart';
import '/controllers/firebase_authentication/firebase_authentication_controller.dart';
import '/helpers/storage_helper.dart';

class SheetPage extends StatelessWidget {
  const SheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    getEmployees();
    return Column(
      children: [
        // Container(
        //   padding: EdgeInsets.all(5),
        //   alignment: Alignment.centerRight,
        //   child: IconButton(
        //     onPressed: () {
        //       _openSheetForm(context);
        //     },
        //     icon: Icon(
        //       Icons.add_to_photos,
        //       color: Colors.greenAccent,
        //       size: 30,
        //     ),
        //   ),
        // ),
        Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: employeeList.length,
                  itemBuilder: (context, index) {
                    var data = employeeList[index].data();
                    return ListTile(
                      onTap: () => {
                        print(data),
                      },
                      title: Text(data['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          data['sheetId'] == null
                              ? IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.blue,
                                  onPressed: () => {},
                                )
                              : IconButton(
                                  icon: Icon(Icons.add_to_photos),
                                  color: Colors.blue,
                                  onPressed: () => {},
                                ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.redAccent,
                            onPressed: () => {},
                          )
                        ],
                      ),
                    );
                  },
                )))
      ],
    );
  }
}

Future<void> _openSheetForm(BuildContext context) async {
  var screenWidth = MediaQuery.of(context).size.width;
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
            width: min(screenWidth, 400),
            child: Column(
              children: [
                Title(
                  color: Colors.black,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.green,
                    ),
                    child: Text(
                      'ADD NEW SHEET',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Colors.grey[100],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: sheetLink.value,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              adminEmail.value.text = 'malsawma7777@gmail.com';
                              adminPassword.value.text = 'arpuisente';
                              adminLogin();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Submit'),
                                Container(
                                  child: Icon(Icons.chevron_right),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      );
    },
  );
}
