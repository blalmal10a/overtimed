import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
