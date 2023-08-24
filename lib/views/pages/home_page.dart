import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overtimed/helpers/form_helper.dart';
import 'package:overtimed/helpers/storage_helper.dart';
import 'package:overtimed/selectedIndex.dart';

class HomePage extends StatelessWidget {
  final isTrashed;
  HomePage({this.isTrashed});

  @override
  Widget build(BuildContext context) {
    documentId.value = '';
    final now = DateTime.now();
    final year = now.year;
    final nthMonth = 8; //august

    final startOfMonth = DateTime(year, nthMonth, 1);
    final endOfMonth =
        DateTime(year, nthMonth + 1, 1).subtract(Duration(days: 1));
    var collectionName = 'trash';

    void setCollectionName() async {
      if (collectionName.isNotEmpty) {
        var asdf = localStorage.setString('collection-name', collectionName);
      } else {
        collectionName = localStorage.getString('collection-name') ?? 'trash';
      }
    }

    // if (authUser.isDefinedAndNotNull && isTrashed != true) {
    //   collectionName = "${authUser?.displayName}_${authUser?.id}";
    //   setCollectionName();
    // } else {
    //   collectionName = localStorage.getString('collection-name') ?? 'trash';
    // }
    collectionName = localStorage.getString('collection-name') ?? 'trash';

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
                final document = documents[index];
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
                  trailing: IconButton(
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
                  title: Text(name),
                  subtitle:
                      Text('$monthDate, $startFormatted to $endFormatted'),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
