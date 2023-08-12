import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'selectedIndex.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationRailApp(),
    );
  }
}

class NavigationRailApp extends StatelessWidget {
  final List<Widget> _pages = [
    HomePage(),
    HomePage(isTrashed: true),
    AddPage(),
  ];

  void _onItemTapped(int index) {
    selectedIndex.state.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Overtime'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Obx(() => _pages[selectedIndex.state.value]),
          ),
          Obx(() => NavigationRail(
                selectedIndex: selectedIndex.state.value,
                onDestinationSelected: _onItemTapped,
                labelType: NavigationRailLabelType.selected,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.app_blocking),
                    label: Text('Trash'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.add),
                    label: Text('Add'),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

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
                        _showToast(context, message);

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

void _showToast(BuildContext context, String toastMessage) {
  final scaffold = ScaffoldMessenger.of(context);

  scaffold.showSnackBar(
    SnackBar(
      content: Text(toastMessage),
      action: SnackBarAction(
          label: 'Hide', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

class HomePage extends StatelessWidget {
  final isTrashed;
  HomePage({this.isTrashed});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final year = now.year;
    final nthMonth = 8; // Replace with the desired month value

    final startOfMonth = DateTime(year, nthMonth, 1);
    final endOfMonth =
        DateTime(year, nthMonth + 1, 1).subtract(Duration(days: 1));
    var collectionName = 'items';
    if (isTrashed == true) collectionName = 'trash';
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(collectionName)
          .where('date',
              isGreaterThanOrEqualTo: startOfMonth,
              isLessThanOrEqualTo: endOfMonth)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final documents = snapshot.data!.docs;
        return Center(
          child: Container(
            width: min(MediaQuery.of(context).size.width, 300),
            child: ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final data = documents[index].data() as Map<String, dynamic>;
                final name = data['name'] ?? '';
                final dateTimestamp = data['date'] as Timestamp;
                final startTimestamp = data['start_time'] as Timestamp;
                final endTimestamp = data['end_time'] as Timestamp;
                final dateDateTime = dateTimestamp.toDate();
                final monthDate = DateFormat('d MMM').format(dateDateTime);
                final startDateTime = startTimestamp.toDate();
                final endDateTime = endTimestamp.toDate();
                final startFormatted = DateFormat.jm().format(startDateTime);
                final endFormatted = DateFormat.jm().format(endDateTime);
                return ListTile(
                  trailing: Icon(
                    Icons.check_circle_outline,
                    color: Colors.blueGrey,
                    size: 27,
                  ),
                  title: Text(name),
                  subtitle:
                      Text('$monthDate, $startFormatted to $endFormatted'),
                );
              },
            ),
          ),
        );
        // return ListView.builder(
        //   itemCount: documents.length,
        //   itemBuilder: (context, index) {
        //     final data = documents[index].data() as Map<String, dynamic>;
        //     final name = data['name'] ?? '';
        //     final dateTimestamp = data['date'] as Timestamp;
        //     final startTimestamp = data['start_time'] as Timestamp;
        //     final endTimestamp = data['end_time'] as Timestamp;
        //     final dateDateTime = dateTimestamp.toDate();
        //     final monthDate = DateFormat('d MMM').format(dateDateTime);
        //     final startDateTime = startTimestamp.toDate();
        //     final endDateTime = endTimestamp.toDate();
        //     final startFormatted = DateFormat.jm().format(startDateTime);
        //     final endFormatted = DateFormat.jm().format(endDateTime);
        //     return ListTile(
        //       title: Text(name),
        //       subtitle: Text('$monthDate, $startFormatted to $endFormatted'),
        //     );
        //   },
        // );
      },
    );
  }
}
