import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart' as http;

import 'package:googleapis/sheets/v4.dart' as sheets;

final fileMime = "application/vnd.google-apps.file";
final folderMime = "application/vnd.google-apps.folder";
late DriveApi driveApi;
late sheets.SheetsApi sheetsApi;
late GoogleSignIn signIn;

class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

Future<Map<String, dynamic>> authenticateUser() async {
  final scopeList = [
    'https://www.googleapis.com/auth/drive',
    'https://www.googleapis.com/auth/spreadsheets'
  ];
  signIn = GoogleSignIn.standard(scopes: scopeList);

  final account = await signIn.signIn();

  if (account == null) {
    throw Exception("Account authentication failed");
  }

  driveApi = DriveApi(_GoogleAuthClient(await account.authHeaders));
  sheetsApi = sheets.SheetsApi(_GoogleAuthClient(await account.authHeaders));
  // insertIntoFile();
  // final lastRow = await getLastDataRow();
  // print('last row is $lastRow');
  // deleteRowAndShiftRowsUp(1);
  // final gridId = await getSheetIdBySheetName('asdf.csv');
  try {} catch (e) {
    print('error in here $e');
  }
  // final String sheetTitle = await retrieveAndPrintSheetContent();

  // await writeToA7andB7(
  //     '1jevwdVSTkuXrLuTHPARKdOoiHo4FNszRToXUUskPhiw', sheetTitle);

  // await writeToSheet(
  //     '1jevwdVSTkuXrLuTHPARKdOoiHo4FNszRToXUUskPhiw', sheetTitle);
  // await createMoreSheet();

  return {
    'driveApi': driveApi,
    'sheetsApi': sheetsApi,
    'account': account,
    'signIn': signIn,
  };
}
