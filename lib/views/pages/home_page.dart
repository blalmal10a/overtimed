import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '/helpers/form_helper.dart';
import '/helpers/storage_helper.dart';
import '/helpers/selectedIndex.dart';

class HomePage extends StatelessWidget {
  final isTrashed;
  HomePage({this.isTrashed});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final year = now.year;
    final nthMonth = DateTime.now().month;
    ; //august

    final startOfMonth = DateTime(year, nthMonth, 1);
    final endOfMonth =
        DateTime(year, nthMonth + 1, 1).subtract(Duration(days: 1));
    var collectionName = 'trash';

    collectionName = localStorage.getString('collection-name') ?? 'trash';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(this.isTrashed == null ? collectionName : 'trash')
          // .where('date',
          //     isGreaterThanOrEqualTo: startOfMonth,
          //     isLessThanOrEqualTo: endOfMonth)
          .orderBy('date', descending: true)
          .limit(50)
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
                final document = documents[index];
                final data = documents[index].data() as Map<String, dynamic>;
                final name = data['name'] ?? '';
                // final dateTimestamp = data['date'] as Timestamp;
                final startTimestamp = data['start_time'] as Timestamp;
                final endTimestamp = data['end_time'] as Timestamp;
                final startDateTime = startTimestamp.toDate();
                final endDateTime = endTimestamp.toDate();
                final monthDate = DateFormat('d MMM').format(startDateTime);
                final startFormatted = DateFormat.jm().format(startDateTime);
                final endFormatted = DateFormat.jm().format(endDateTime);
                return ListTile(
                  title: Text(name),
                  subtitle:
                      Text('$monthDate, $startFormatted to $endFormatted'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          try {
                            print(document.id);
                            documentId.value = document.id;
                            endTime.value = data['end_time'].toDate();
                            startTime.value = data['start_time'].toDate();
                            overtimeProjectName.value.text = data['name'];

                            selectedIndex.state.value = 2;
                          } catch (e) {
                            print(e);
                          }
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.blueGrey,
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            documentId.value = document.id;
                            print(document.id);
                            projectName.value = data['name'];
                            _dialogBuilder(context);
                          } catch (e) {
                            print(e);
                          }
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.redAccent,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      final String deleteItem = projectName.value ?? 'the selected item';

      return AlertDialog(
        title: const Text('Confirm delete'),
        content: Text(
          'Are you sure you want to delete `$deleteItem`',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Confirm'),
            onPressed: () async {
              await onConfirmDelete();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
