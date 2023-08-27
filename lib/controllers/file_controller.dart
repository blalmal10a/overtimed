import '/controllers/user_authentication.dart';
import '/helpers/spreadsheet_helper.dart';
import 'package:googleapis/drive/v3.dart';

import 'package:googleapis/sheets/v4.dart' as sheets;

String getFileIdFromUrl(url) {
  final pattern = RegExp(r'/d/([a-zA-Z0-9-_]+)');
  final match = pattern.firstMatch(url);

  if (match != null && match.groupCount >= 1) {
    return match.group(1)!;
  } else {
    throw ArgumentError('Invalid Google Sheets URL format');
  }
}

Future<List<String>> getFileIdFromName(String fileName) async {
  final search = await driveApi.files.list(
    q: "name='$fileName' and trashed=false",
    spaces:
        "drive${signIn.scopes.contains(DriveApi.driveAppdataScope) ? ", appDataFolder" : ""}",
  );

  List<String> result = List.empty(growable: true);
  if (search.files == null || search.files!.isEmpty) {
    throw "File not found";
  } else {
    search.files!.forEach((file) => result.add(file.id!));
  }
  return result;
}

Future getFileById(String fileId) async {
  return await driveApi.files.get(fileId);
}

Future<void> insertIntoFile() async {
// Future<void> insertIntoFile(
//     DriveApi driveApi, sheets.SheetsApi sheetsApi) async {
  // final spreadsheetId = '1jevwdVSTkuXrLuTHPARKdOoiHo4FNszRToXUUskPhiw';
  final range = 'August 2023!A3:B3';
  // final range = 'Sheet1!A3:B3';
  final values = [
    ['Value for A3', 'Value for B3'],
  ];

  final valueRange = sheets.ValueRange(values: values);

  await sheetsApi.spreadsheets.values.update(
    valueRange,
    spreadsheetId.value ?? '',
    range,
    valueInputOption: 'RAW', // Use 'USER_ENTERED' for formatted input
  );

  print('Data inserted into A3 and B3');
}

Future<String> retrieveAndPrintSheetContent() async {
  try {
    final spreadsheet =
        await sheetsApi.spreadsheets.get(spreadsheetId.value ?? '');
    final sheet = spreadsheet.sheets![0];
    final String sheetTitle = sheet.properties!.title ?? '';
    final values = await sheetsApi.spreadsheets.values
        .get(spreadsheetId.value ?? '', sheetTitle);

    final valueValues = values.values;
    if (valueValues != null) {
      print('values are : $valueValues');
      for (var i = 0; i < valueValues.length; i++) {
        print(valueValues[i]);
      }
    }
    return sheetTitle;
  } catch (e) {
    print('GET SHEETS ERROR $e');
    return 'nothing';
  }
}

// Future<void> createFileInDrive(
//     fileName, mimeType, List<String>? parents, String text) async {
//   try {
//     final newFile = await driveApi.files.create(
//       File(name: fileName, mimeType: mimeType, parents: parents),
//       uploadMedia: text.isNotEmpty
//           ? Media(
//               Stream.value(ascii.encode(text)),
//               text.length,
//             )
//           : null,
//     );

//     print('New file created with ID: ${newFile.id}');
//   } catch (e) {
//     print('error in here $e');
//   }
// }

Future<void> writeToSheet(String spreadsheetId, String sheetTitle) async {
  final valuesToWrite = [
    ['New Value 1', 'New Value 2', 'New Value 3'],
    ['Another Value 1', 'Another Value 2', 'Another Value 3'],
  ];
  try {
    final valueRange = sheets.ValueRange(values: valuesToWrite);
    final result = await sheetsApi.spreadsheets.values.update(
      valueRange,
      spreadsheetId,
      sheetTitle,
      valueInputOption:
          'RAW', // You can change this to 'USER_ENTERED' if needed
    );

    print('Write result: ${result.toJson()}');
  } catch (e) {
    print('WRITE TO SHEET ERROR $e');
  }
}

Future<void> writeToA7andB7(String spreadsheetId, String sheetTitle) async {
  final valuesToWrite = [
    ['value of a7', '', 'value of b7']
  ];

  try {
    final valueRange = sheets.ValueRange(values: valuesToWrite);
    final result = await sheetsApi.spreadsheets.values.update(
      valueRange,
      spreadsheetId,
      '$sheetTitle!A7:C7', // Specify the range as A7:B7
      valueInputOption:
          'RAW', // You can change this to 'USER_ENTERED' if needed
    );

    print('Write result: ${result.toJson()}');
  } catch (e) {
    print('WRITE TO SHEET ERROR $e');
  }
}

Future<void> createMoreSheet() async {
  await sheetsApi.spreadsheets.batchUpdate(
    sheets.BatchUpdateSpreadsheetRequest.fromJson({
      'requests': [
        {
          'addSheet': {
            'properties': {
              'title': 'August 2023',
            }
          }
        }
      ]
    }),
    spreadsheetId.value ?? '',
  );
}

Future<dynamic> getLastDataRow() async {
  try {
    final range = "'August 2023'!A:A"; // Range covering all rows in A column

    final response = await sheetsApi.spreadsheets.values.get(
      spreadsheetId.value ?? '',
      range,
    );

    final values = response.values;
    if (values == null || values.isEmpty) {
      // No data found
      return 0;
    }

    // Find the last non-empty row
    for (var i = values.length - 1; i >= 0; i--) {
      final row = values[i];
      if (row.isNotEmpty) {
        return i +
            1; // Adding 1 to convert from 0-based index to 1-based row number
      }
    }

    // No non-empty row found
    return null;
  } catch (e) {
    print('Error: $e');
    return 0;
  }
}

Future<int?> getSheetIdBySheetName(String? sheetName) async {
  try {
    if (sheetName == null) {
      sheetName = 'August 2023';
    }
    final spreadsheet =
        await sheetsApi.spreadsheets.get(spreadsheetId.value ?? '');
    final sheetsList = spreadsheet.sheets;

    if (sheetsList!.isNotEmpty) {
      for (final sheet in sheetsList) {
        if (sheet.properties?.title == sheetName) {
          final gridId = sheet.properties?.sheetId;
          print('grid id is $gridId');

          return gridId;
        }
      }
    }
    return null; // Sheet not found
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

Future<void> deleteRowAndShiftRowsUp(int rowToDelete) async {
  try {
    final requests = [
      sheets.Request.fromJson({
        'deleteDimension': {
          'range': {
            'sheetId':
                1644393544, // Sheet ID of 'August 2023' (modify if needed)
            'dimension': 'ROWS',
            'startIndex': rowToDelete - 1, // Convert to 0-based index
            'endIndex': rowToDelete, // Delete a single row
          }
        }
      })
    ];

    // await sheetsApi.spreadsheets.batchUpdate(
    //   sheets.BatchUpdateSpreadsheetRequest.fromJson({'requests': requests}),
    //   spreadsheetId.value ?? '',
    // );
    final batchUpdateRequest = sheets.BatchUpdateSpreadsheetRequest()
      ..requests = requests;

    await sheetsApi.spreadsheets.batchUpdate(
      batchUpdateRequest,
      spreadsheetId.value ?? '',
    );

    print('Row $rowToDelete deleted and rows shifted up.');
  } catch (e) {
    print('Error: $e');
  }
}
