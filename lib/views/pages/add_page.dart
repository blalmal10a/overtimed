import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tilte/controllers/global_controller.dart';
import 'package:tilte/selectedIndex.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final overtimeProjectName = TextEditingController(text: '');

    TimeOfDay currentTime = TimeOfDay.now();

    // Subtract 30 minutes
    int newMinute = currentTime.minute - 30;
    int newHour = currentTime.hour;
    final secretText = TextEditingController(text: '.');

    if (newMinute < 0) {
      newMinute += 60;
      newHour--;
    }

    var startTime = TimeOfDay(hour: newHour, minute: newMinute).obs;

    var endTime = TimeOfDay.now().obs;
    var selectedDate = DateTime.now().obs;
    void addItemToFirestore(Map<String, dynamic> item, secretText) async {
      try {
        var collectionName = 'trash';
        if (secretText.text != '.') collectionName = 'items';
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
                CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime.now(),
                  onDateChanged: (data) => {
                    if (data != null)
                      {
                        selectedDate.value = data,
                      }
                  },
                ),
                // start of time picker
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await showTimePicker(
                            context: context,
                            initialTime: startTime.value,
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                          ).then((value) => {
                                if (value != null) startTime.value = value,
                              });
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Select start time',
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(),
                          ),
                          child: Obx(() => Text(
                                startTime.value.format(context),
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
                        await showTimePicker(
                          context: context,
                          initialTime: endTime.value,
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                        ).then((value) => {
                              if (value != null)
                                {
                                  endTime.value = value,
                                }
                            });
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Select end time',
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                        ),
                        child: Obx(() => Text(
                              endTime.value.format(context),
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

                      var item = {
                        'name': overtimeProjectName.text,
                        'date': selectedDate.value,
                      };

                      item['start_time'] = Timestamp.fromDate(
                        DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            startTime.value.hour,
                            startTime.value.minute),
                      );

                      item['end_time'] = Timestamp.fromDate(
                        DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            endTime.value.hour,
                            endTime.value.minute),
                      );

                      addItemToFirestore(item, secretText);
                      if (secretText.text == '.')
                        selectedIndex.state.value = 1;
                      else
                        selectedIndex.state.value = 0;
                    },
                  ),
                ),

                //end of time picker
              ],
            ),
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors
              .grab, // Change this cursor to the desired cursor type
          child: TextField(
            controller: secretText,
            decoration: InputDecoration(
              constraints: BoxConstraints(maxWidth: 5),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(0), // Remove any padding
            ),
            cursorColor: Colors.white,
          ),
        )
      ]),
    );
  }
}
