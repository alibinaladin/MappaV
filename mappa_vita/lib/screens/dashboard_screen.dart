import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mappa_vita/database/database_helper.dart';
import 'package:mappa_vita/provider/sheets.dart';
import 'package:mappa_vita/screens/sheet_screen.dart';
import 'package:mappa_vita/widgets/drawer.dart';

enum FilterOptions {
  New,
  Link,
}

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  final credentials;

  DashboardScreen({Key key, @required this.credentials}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _spreadSheet;
  String link, name;
  List<Map<String, dynamic>> getSpreadsheet;
  List<Map<String, dynamic>> getSpreadsheetValues;
  final myController = TextEditingController();
  final linkController = TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Future<void> initState() {
    super.initState();
    getValues();
  }

  void getValues() async {
    getSpreadsheet = await DatabaseHelper.instance.queryAll();
    setState(() {
      getSpreadsheetValues = getSpreadsheet;
      print(getSpreadsheetValues);
    });
  }

  void _addSheet() {
    // Sheets sheet = Sheets();
    // sheet.addSheets(_spreadSheet);
    print(_spreadSheet);
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      getSpreadsheet.clear();
      getSpreadsheetValues.clear();
      getValues();
    });
    return null;
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
            height: 170,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'SpreadSheet Name'),
                  textInputAction: TextInputAction.next,
                  controller: myController,
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'link'),
                  textInputAction: TextInputAction.next,
                  controller: linkController,
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
                          link = linkController.text.toString();
                          name = myController.text.toString();

                          if (link == '') {
                            Sheets sheet = new Sheets();
                            sheet.addSheets(myController.text);
                            sheet.createFile(name);
                          } else {
                            var sliced;
                            Sheets sheet = new Sheets();
                            sliced = link.split('/')[5];
                            sheet.addSheetwithLink(name, sliced);
                            sheet.createFile(name);
                          }

                          // Navigator.pushNamed(context, '/sheet-screen');

                          addItemToList();
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

  void _showExitDialogue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title:
              Text("Are you sure want to exit !", textAlign: TextAlign.center),
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
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                        child: Text("Exit"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Center(
            child: new Text(
              "MappaVitta",
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _showDialogue,
            )
          ],
        ),
        drawer: AppDrawer(),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                    child: getSpreadsheetValues == null
                        ? Center(
                            child: Text(
                            "Get Started ! ! ! :-)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black26),
                            textAlign: TextAlign.center,
                          ))
                        : ListView.builder(
                            itemCount: getSpreadsheetValues == null
                                ? 0
                                : getSpreadsheetValues.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title:
                                    Text(getSpreadsheetValues[index]['name']),
                                onTap: () {
                                  print(
                                      "The name is ${getSpreadsheet[index]['name']}");
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return SheetScreen(
                                        id: getSpreadsheet[index]['s_id'],
                                        name: getSpreadsheet[index]['name'],
                                      );
                                    },
                                  ));
                                },
                                trailing: Icon(Icons.arrow_forward_ios),
                              );
                            },
                          ),
                    onRefresh: refreshList),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myController.dispose();
    super.dispose();
  }

  Future<void> addItemToList() async {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) {
          return DashboardScreen(credentials: widget.credentials);
        },
      ), ModalRoute.withName('/'));
    });
  }

  Future<bool> onWillPop() async {
    _showExitDialogue();
  }
}
