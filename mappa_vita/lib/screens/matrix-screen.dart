import 'package:flutter/material.dart';

void main() => runApp(MatrixScreen());

/// This is the main application widget.
class MatrixScreen extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: MyStatelessWidget(),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyStatelessWidget extends StatefulWidget {
  MyStatelessWidget({Key key}) : super(key: key);

  @override
  _MyStatelessWidgetState createState() => _MyStatelessWidgetState();
}

class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  List<DataColumn> cols = [];
  List<DataRow> rows = [];
  List<TextEditingController> contro = [];

  @override
  void initState() {
    addColumns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> _controller =
        List.generate(10, (i) => TextEditingController());
    List<TextField> fields =
        List.generate(10, (i) => TextField(controller: _controller[i]));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.refresh,
          color: Colors.white,
          size: 29,
        ),
        backgroundColor: Colors.black,
        tooltip: 'Capture Picture',
        elevation: 5,
        splashColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [Text("data")],
                )),
          ],
        ),
      ),
    );
  }

  void addColumns() {
    for (var i = 0; i < 10; i++) {
      cols.add(
        DataColumn(
          label: Text(
            i.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }
    addRow();
  }

  void addRow() {
    List<TextEditingController> _controller =
        List.generate(10, (i) => TextEditingController());
    List<TextField> fields =
        List.generate(10, (i) => TextField(controller: _controller[i]));
  }

  void controllers() {
    var con;
    for (var i = 1; i <= 1000; i++) {
      con = i;
      contro.add(con = TextEditingController());
    }

    print("the controllers are $contro");
  }

  void addDynamicRow() {
    setState(() {
      dynamicController();
      for (var i = 1; i <= 50; i++) {
        rows.insert(
          rows.length,
          DataRow(cells: [
            DataCell(TextField(
              controller: contro[i * 1],
            )),
            DataCell(TextField(
              controller: contro[i * 2],
            )),
            DataCell(TextField(
              controller: contro[i * 3],
            )),
            DataCell(TextField(
              controller: contro[i * 4],
            )),
            DataCell(TextField(
              controller: contro[i * 5],
            )),
            DataCell(TextField(
              controller: contro[i * 6],
            )),
            DataCell(TextField(
              controller: contro[i * 7],
            )),
            DataCell(TextField(
              controller: contro[i + 8],
            )),
            DataCell(TextField(
              controller: contro[i + 9],
            )),
            DataCell(TextField(
              controller: contro[i + 10],
            )),
          ]),
        );
      }

      print("The dynamic row adding is ");
      print(rows.length);
      print(cols.length);
    });
  }

  void save() {
    print("The text of the field is ---------------->");
    print(contro[1].text);
  }

  void dynamicController() {
    print(rows.length);
    var limit = rows.length * 10;
    var con;
    for (var i = 1; i <= limit; i++) {
      con = i;
      contro.add(con = TextEditingController());
    }
  }

// Future<void> sample() async {
//   var excel = Excel.createExcel();
//   Sheet sheetObject = excel['Sheet1'];
//   final directory = await getExternalStorageDirectory();
//   var status = await Permission.storage.status;
//
//   if (status.isGranted) {
//     await excel.encode().then((value) {
//       File(join('${directory.path}/hello.xlsx'))
//         ..createSync(recursive: true)
//         ..writeAsBytesSync(value);
//
//       Sheets sheets = new Sheets();
//       sheets.uploadFileToGoogleDrive('${directory.path}/hello.xlsx', "hii");
//     });
//   } else {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.storage,
//     ].request();
//   }
// }
}
