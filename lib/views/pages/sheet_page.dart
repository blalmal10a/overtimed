import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/deploymentmanager/v2.dart';
import '/controllers/employee_sheet/employee_sheet_controller.dart';
import '/controllers/firebase_authentication/firebase_authentication_controller.dart';
import '/helpers/storage_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class SheetPage extends StatelessWidget {
  const SheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
            child: Container(
          margin: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          width: min(400, screenWidth),
          child: Obx(
            () => ListView.builder(
              itemCount: employeeList.length,
              itemBuilder: (context, index) {
                var data = employeeList[index].data() as Map;
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onTap: () {
                    selectedEmployee.value = data;

                    sheetLink.value.text = data['sheet_link'] ?? '';
                    _openSheetForm(context);
                    // updateEmployee();
                  },
                  title: Text(data['name']),
                  // trailing:
                  //  IconButton(
                  //   icon: Icon(Icons.delete),
                  //   color: Colors.redAccent,
                  //   onPressed: () => {},
                  // )
                  leading: Icon(
                    Icons.manage_accounts,
                    color: Colors.green,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.call_made),
                        color: Colors.blue,
                        onPressed: () async {
                          final url = Uri.parse(data['sheet_link']);

                          print('url is $url');
                          try {
                            await launchUrl(url);
                          } catch (e) {
                            print(e);
                          }
                          // if (await canLaunchUrl(url)) {
                          // } else
                          //   print("couldn't launch URL");
                        },
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
            ),
          ),
        )),
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
            width: screenWidth,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Assign sheet to ' + selectedEmployee['name'],
                          style: TextStyle(color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.green)),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        )
                      ],
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
                              updateEmployee();
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
