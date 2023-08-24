import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:overtimed/controllers/user_authentication.dart';
import '/controllers/global_controller.dart';
import '/selectedIndex.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final overtimeProjectName = TextEditingController(text: '');

    // TimeOfDay currentTime = TimeOfDay.now();
    final Rx<DateTime?> startTime =
        DateTime.now().subtract(Duration(hours: 1)).obs;
    final Rx<DateTime?> endTime = DateTime.now().obs;

    void addItemToFirestore(Map<String, dynamic> item) async {
      try {
        var collectionName = 'trash';
        if (authUser.isDefinedAndNotNull) {
          collectionName = "${authUser.displayName}_${authUser.id}";
        }
        CollectionReference items =
            FirebaseFirestore.instance.collection(collectionName);

        await items.add(item);
      } catch (e) {
        ('error is $e');
      }
    }

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: overtimeProjectName,
                  decoration: InputDecoration(
                    label: Text('Project name'),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          startTime.value =
                              await showOmniDateTimePicker(context: context) ??
                                  startTime.value;
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Select start time',
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                          ),
                          child: Obx(() => Text(
                                DateFormat('dd-MMM-yyyy hh:mm a')
                                    .format(startTime.value ?? DateTime.now()),
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        endTime.value =
                            await showOmniDateTimePicker(context: context) ??
                                endTime.value;
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Select end time',
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                        ),
                        child: Obx(() => Text(
                              DateFormat('dd-MMM-yyyy hh:mm a')
                                  .format(endTime.value ?? DateTime.now()),
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                    ))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: ElevatedButton(
                    child: Text('Submit'),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        Size(200, 50),
                      ),
                    ),
                    onPressed: () {
                      String? message = null;
                      if (overtimeProjectName.text.isEmpty) {
                        message = 'Enter project name';
                      }

                      if (message != null) {
                        showToast(context, message);

                        return;
                      }

                      // var item = {
                      //   'name': overtimeProjectName.text,
                      //   'date': selectedDate.value,
                      // };
                      var item = {
                        'name': overtimeProjectName.text,
                        'date': DateTime.now(),
                        'start_time': startTime.value,
                        'end_time': endTime.value,
                      };

                      addItemToFirestore(item);

                      selectedIndex.state.value = 0;
                    },
                  ),
                ),

                //end of time picker
              ],
            ),
          ),
        ),
        // MouseRegion(
        //   cursor: SystemMouseCursors
        //       .grab, // Change this cursor to the desired cursor type
        //   child: TextField(
        //     controller: secretText,
        //     decoration: InputDecoration(
        //       constraints: BoxConstraints(maxWidth: 5),
        //       border: InputBorder.none,
        //       focusedBorder: InputBorder.none,
        //       enabledBorder: InputBorder.none,
        //       errorBorder: InputBorder.none,
        //       disabledBorder: InputBorder.none,
        //       contentPadding: EdgeInsets.all(0), // Remove any padding
        //     ),
        //     cursorColor: Colors.white,
        //   ),
        // )
      ]),
    );
  }
}
