import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gsheets/gsheets.dart';
import 'package:mappa_vita/provider/sheets.dart';
import 'package:mappa_vita/screens/matrix-screen.dart';

class SheetScreen extends StatefulWidget {
  static const routeName = '/sheet-screen';

  var id;
  var name;

  SheetScreen({Key key, @required this.id, @required this.name})
      : super(key: key);
  @override
  _SheetScreenState createState() => _SheetScreenState();
}

class _SheetScreenState extends State<SheetScreen> {
  Sheets sheet = Sheets();
  List<String> nameList = [];
  List<String> sheetId = [];
  List<Worksheet> getSheets;
  List<Worksheet> getSheetsValues;
  final myController = TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var worksheet;
  List<List<String>> datas = [];

  @override
  void initState() {
    getWorksheetsById();
    datas.insert(0, ['hiiii']);
    super.initState();
  }

  void getWorksheetsById() async {
    getSheets = await sheet.getWorksheets(widget.id);

    this.setState(() {
      getSheetsValues = getSheets;
      getSheetsValues.forEach((element) {
        nameList.insert(nameList.length, element.title);
        sheetId.insert(sheetId.length, element.spreadsheetId);
      });
    });
    print(nameList);
  }

  void _showDialogue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: Text("Create a Spreadsheet", textAlign: TextAlign.center),
          content: Container(
            height: 70,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'SpreadSheet Name'),
                  textInputAction: TextInputAction.next,
                  controller: myController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
                height: 50,
                width: 280,
                child: Row(children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                    ),
                  )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        onPressed: () {
                          this.setState(() {
                            if (nameList.contains(myController.text)) {
                              Fluttertoast.showToast(
                                  msg:
                                      "The name you entered is already exist !",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              worksheet = sheet
                                  .createExcelSheet(
                                      widget.name, myController.text)
                                  .then((value) {
                                print(value.name);
                                refreshList();
                                setState(() {});
                              });
                            }
                            // refreshSheets();
                            // getWorksheetsById();
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("Save"),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                  )
                ]))
          ],
        );
      },
    );
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      nameList.clear();
      getWorksheetsById();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Center(
          child: new Text(
            "Sheets",
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.gamepad),
            onPressed: () {
              // print("hello");
              _showDialogue();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
                child: getSheetsValues == null
                    ? Center(
                        child: Text(
                        "Getting Started ! !",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ))
                    : ListView.builder(
                        itemCount: nameList.length,
                        itemBuilder: (context, index) {
                          return list(index);
                        },
                      ),
                onRefresh: refreshList),
          ),
        ],
      ),
    );
  }

  Widget list(index) {
    return Dismissible(
      key: ValueKey(sheetId[index]),
      onDismissed: (direction) {
        Sheets sheet = new Sheets();
        sheet.deleteSheet(nameList[index], sheetId[index]);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      child: ListTile(
        title: Text(nameList[index]),
        onTap: () {
          print("The ontap id is");
          print(sheetId[index]);

          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MatrixScreen();
          }));
        },
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  @override
  void didUpdateWidget(SheetScreen sheet) {
    super.didUpdateWidget(sheet);
  }

  Future<void> refreshSheets() async {
    nameList.clear();
    getSheets = await sheet.getWorksheets(widget.id).then((value) {
      this.setState(() {
        getSheetsValues = getSheets;
        getSheetsValues.forEach((element) {
          nameList.insert(nameList.length, element.title);
        });
      });
    });
  }
}
