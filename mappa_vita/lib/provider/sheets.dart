import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gsheets/gsheets.dart';
import 'package:googleapis/sheets/v4.dart' as v4;
import 'package:googleapis/drive/v3.dart' as driveAPI;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mappa_vita/database/database_helper.dart';
import 'package:mappa_vita/screens/sign_in.dart';

class Sheets with ChangeNotifier {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbzJgZGJJtmZwVRPmZILGXEHNNAzNtTTZfMonMcugdm7sLsBqg/exec?action=doGet";

  var _credentials = r'''{
    "type": "service_account",
    "project_id": "mappavita-99224",
    "private_key_id": "1e669203f5a83a09e232f095d07eb59fd86219fc",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDei6rp6QXYoCob\nT4Ob/s4uuy61o+/b8BwnRzvYRLIhRqXCr7YLt1bYIJN+YPSxhzsvPmtmF3921VBs\nKw9/LGijHQKGCPrcvKh/J43/eQPtdyA7NLS/nzBi4NADI2sKMb5aaOpZJvVd3NLg\nBYyglA4lZ70ViAtH+bMSOyewckEaCljbs56Y0TS+0R+dety184j1vDbQwpYn0JtX\nR6zbah4tTRI0mjkAATFKMwL2f17E4cU8OQ0rfN1LHWAvlS1+8/fZwmnS6QFJcJAP\nAsxtBRv2ozJcIPrkHnoy7UPtq8diYw6/KZplL6AQ5N9F1UJseYWghIho2WHfg8Qg\n8899X6KrAgMBAAECggEAD2+3qg7q7ro5Vs3z+Tjk5f0/ga4+inkZXX4a6rw6cNrH\nelLEJAQ9EV5nwf8z/zERTAxz2E/ZRw2yd4uga7f8Wr1ojzyF42lwnz/yoQhXWzwv\n76YPGDA7Y829OqJ/ymQQlJEsxC9SxgZ1rWqlH6mgC5HVCJki/dnrmmBLt05Nhrfq\nMMjJvhb+Vm4heQjdfoMoM4NzRGAI0BuED6jwN2xO7PAQD+b/X4FXEBYUkaPzXXO4\nAiwJEaHo8bVOYuWBL1rmWB1Wt3+4/kM85nTjGr6lKFTA9nwKD+AQVRFxGrbn06U1\ngEc+rKjudA4Shdy1NyljdXTyzHsEB808w2QbNfoijQKBgQD7vUCVTNEMkpyCHj8g\nm+9BIDZWhuEucHT1xBIFcEjoq5+ipeACS1bx2egG/2NrTrcfqYeGayNjEa4GP7Gb\nSKsHIzN+mBSin7vUTIqfKh6nM8cGvXxJld3zaV6TJbqD+G23jAPx+1m0h75O2R9b\njgr5thO2SOMkn0isKlR2kxJxvwKBgQDiT+xujJ5XYOserM0yEgCGCyLPo3OnoEmp\nzrwh6+Stt2v1uKkA1KF32hnvK1TF2gcV/AnEreq11jsYQxKjAuR2agsrWDOP1h3K\nM/TuN+LKrk9Yx9Gvl8YkRAJL0VGA/efytxlKONhAMnrdITnE5jnDT4Ncv70k8T4v\n8kskDJsyFQKBgAV0WE3j2DO5iYKYPS3rswdqN0MwsPhcn2wjz3Amuq2v6kmP5oam\nM0ASRKDCL9lHX1hkR/d1otKms2qXPrXqoSoKbTc0/F15sIwtDGPeecONr6ZJvMOr\nZ5+6jL4LdzscyuPLONqpY4wx1MHImpFVRo+ajlrIwYMtoFl6oVHgZenpAoGBAM8L\nGZ3lzfLYuyH8K1oUeCApzfYyblu728ibVyidfD+lYAKUpyEYZoSUp0dU2CCOIA9v\n3qvuBJ3I2ZWPv1wdCFCBIajM75c251gXAoxx2m1c3UC2xlIjw2VoRsWAQVWGdQ5r\njpqFuOm6hQcLH6PQkKXrd52B2RQUFLWesDnRwqYlAoGBANFZ4XXN9ypyfI3Kbcn8\nKdEdf7+oS7raO8NpKn+P3upSgscMUMHoQg0NPKLusRwfl882gAKAJ9I/2FRqrIZ1\nqTmu6UEZSxZGLHf3flwVovG9JrDijtY3E2RmvqZ2uty3xw5emxtuU2ytrVFwjMo2\nuVJKowaW8hSWRxOszflm/3bN\n-----END PRIVATE KEY-----\n",
    "client_email": "mappavita-99224@appspot.gserviceaccount.com",
    "client_id": "111676915493259903423",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/mappavita-99224%40appspot.gserviceaccount.com"
  }''';

  var gsheets;

  void addSheets(String name) async {
    var scope = [
      'https://www.googleapis.com/auth/drive',
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/spreadsheets',
      'https://www.googleapis.com/ auth/userinfo.profile'
    ];
    // var fileMetadata = {
    //   'name': 'Mappavitta',
    //   'mimeType': 'application/vnd.google-apps.folder'
    // };
    // final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    // var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    // var mydrive = driveAPI.DriveApi(client);
    // var drive = driveAPI.USER_AGENT;
    // var response = await mydrive.files
    //     .create(driveAPI.File()..name = "Mappavita.csv")
    //     .then((value) => print(value.properties))
    //     .catchError((err) => print(err));

    // signInWithGoogle().then((value) async {
    //   final gsheets = GSheets(_credentials, scopes: scope);
    //   var mysheet;
    //   print(value);
    //   var x = await gsheets.createSpreadsheet("ABCD");
    //   print("Inside the then");
    //   print("The function is executdes");
    //   print(x.sheets);
    //   print("The sheeet is $x");
    // });
    gsheets = GSheets(_credentials,
        scopes: [v4.SheetsApi.SpreadsheetsScope, v4.SheetsApi.DriveScope]);
    print(gsheets);
    var x = await gsheets.createSpreadsheet(name).then((value) async {
      print(value.id);
      await DatabaseHelper.instance.insert({
        DatabaseHelper.columnName: name,
        DatabaseHelper.columnSpreadsheetId: value.id
      });
    });

    // final ss = await gsheets
    //     .spreadsheet("1MMYaTWtgp0JPgtZE3VVe8Lnq7tGP6ucTmZsI_QkkGEc")
    //     .then((value) {
    //   print(value.sheets);
    //   mysheet = value;
    // });

    // var sheet = mysheet.worksheetByIndex(0);

    // print(await sheet.values.value(column: 2, row: 2));
  }

  void addSheetwithLink(String name, String id) async {
    await DatabaseHelper.instance.insert({
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnSpreadsheetId: id
    });
  }

  Future<dynamic> createWorkSheet(String id, String name) async {
    var mysheet;
    gsheets = GSheets(_credentials,
        scopes: [v4.SheetsApi.SpreadsheetsScope, v4.SheetsApi.DriveScope]);
    final ss = await gsheets.spreadsheet(id);
    var sheet = await ss.worksheetByTitle(name);
    sheet ??= await ss.addWorksheet(name);
    return sheet;
  }

  Future<List<Worksheet>> getWorksheets(String id) async {
    gsheets = GSheets(_credentials,
        scopes: [v4.SheetsApi.SpreadsheetsScope, v4.SheetsApi.DriveScope]);
    final ss = await gsheets.spreadsheet(id);
    return await ss.sheets;
  }
}

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;
  GoogleHttpClient(this._headers) : super();
  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) =>
      super.send(request..headers.addAll(_headers));
  @override
  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
