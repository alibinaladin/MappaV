import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gsheets/gsheets.dart';
import 'package:mappa_vita/provider/sheets.dart';

class SheetScreen extends StatefulWidget {
  static const routeName = '/sheet-screen';

  var id;

  SheetScreen({Key key, @required this.id}) : super(key: key);
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

  @override
  void initState() {
    getWorksheetsById();
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
                            Sheets sheet = new Sheets();
                            var worksheet = sheet
                                .createWorkSheet(widget.id, myController.text)
                                .then((value) {
                              // print(value.id);
                              setState(() {});
                              nameList.insert(
                                  nameList.length, myController.text);
                            });
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
    return ListTile(
      title: Text(nameList[index]),
      onTap: () {
        print("The ontap id is");
        print(sheetId[index]);
      },
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }

  @override
  void didUpdateWidget(SheetScreen sheet) {
    super.didUpdateWidget(sheet);
  }

  Future<void> refreshSheets() async {
    print('executing the refresh .................!!!!!!!');
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
