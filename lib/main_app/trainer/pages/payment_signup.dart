import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skilltrain/utils/overlay_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../utils/gender_selector.dart';
import 'package:spannable_grid/spannable_grid.dart';

class PaymentSignup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _PaymentState();
  }
}

class _PaymentState extends State<PaymentSignup> {
  bool _saving = false;
  bool _finished = false;
  String _response;
  bool _selected = false;

  DateTime currenty = DateTime.now();
  String currentDate =
      new DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currenty,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currenty)
      setState(() {
        currentDate =
            new DateFormat("yyyy-MM-dd").format(pickedDate).toString();
      });
  }

  Map<String, dynamic> infoObj = {
    "individual": {
      "address_kana": {
        "city": "トウキョウ",
        "line1": "２－３９ー７",
        "line2": "イリヤ",
        "postal_code": "110-0013",
        "state": "トウキョウト",
        "town": "イリヤ"
      },
      "address_kanji": {
        "city": "東京",
        "line1": "２－３９ー７",
        "line2": "入谷",
        "postal_code": "110-0013",
        "state": "東京都",
        "town": "台東区"
      },
      "dob": {"day": "28", "month": "12", "year": "1993"},
      "email": "",
      "gender": "male",
      "first_name_kanji": "東",
      "first_name_kana": "ア",
      "last_name_kanji": "東",
      "last_name_kana": "ア",
      "phone": "+815031362394"
    },
    "external_account": {
      "account_number": "0001234",
      "routing_number": "1100000"
    },
    "username": ""
  };

  @override
  void initState() {
    super.initState();
    getTrainerEmail();
  }

  Future getTrainerEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final trainerData = await http.get(
        "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers?username=$username");
    final trainerDataDecoded = convert.jsonDecode(trainerData.body);
    infoObj["individual"]["email"] = trainerDataDecoded[0]['email'];
    infoObj["username"] = username;
  }

  final columnSpan = 4;
  final iconSize = 35.0;

  @override
  Widget build(BuildContext context) {
    List<SpannableGridCellData> nameCells = [];
    nameCells.add(
      SpannableGridCellData(
        column: 1,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
        id: "Icon name",
        child: Container(
          child: Center(
            child: new Icon(Icons.person, size: iconSize),
          ),
        ),
      ),
    );
    nameCells.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "First name kanji",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      First Name (Kanji) 名 (漢字)",
              ),
            ),
          ),
        ),
      ),
    );
    nameCells.add(
      SpannableGridCellData(
        column: 2,
        row: 2,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "Last name kanji",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      Last Name (Kanji) 姓 (漢字)",
              ),
            ),
          ),
        ),
      ),
    );
    nameCells.add(
      SpannableGridCellData(
        column: 2,
        row: 3,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "First Name (Kana) 名 (カナ)",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      First Name (Kana) 名 (カナ)",
              ),
            ),
          ),
        ),
      ),
    );
    nameCells.add(
      SpannableGridCellData(
        column: 2,
        row: 4,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "Last Name (Kana) 姓 (カナ)",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      Last Name (Kana) 姓 (カナ)",
              ),
            ),
          ),
        ),
      ),
    );
/////////////////////////Gender//////////////////////////////
    List<SpannableGridCellData> genderCells = [];

    genderCells.add(
      SpannableGridCellData(
        column: 1,
        row: 1,
        columnSpan: 1,
        rowSpan: 2,
        id: "Icon gender",
        child: Container(
          child: Center(
            child: new Icon(MdiIcons.genderMaleFemale, size: iconSize),
          ),
        ),
      ),
    );
    genderCells.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: columnSpan,
        rowSpan: 2,
        id: "a",
        child: Container(
          child: Center(
            child: new GenderSelector(),
          ),
        ),
      ),
    );
/////////////////////////email//////////////////////////////
    List<SpannableGridCellData> emailCells = [];

    emailCells.add(
      SpannableGridCellData(
        column: 1,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
        id: "Icon email",
        child: Container(
          child: Center(
            child: new Icon(Icons.email, size: iconSize),
          ),
        ),
      ),
    );
    emailCells.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "email",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      Email メールアドレス",
              ),
            ),
          ),
        ),
      ),
    );
    /////////////////////////phone//////////////////////////////
    List<SpannableGridCellData> phoneCells = [];

    phoneCells.add(
      SpannableGridCellData(
        column: 1,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
        id: "Icon phone",
        child: Container(
          child: Center(
            child: new Icon(Icons.phone, size: iconSize),
          ),
        ),
      ),
    );
    phoneCells.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "phone",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      Phone 電話番号",
              ),
            ),
          ),
        ),
      ),
    );

    /////////////////////////birthday//////////////////////////////
    List<SpannableGridCellData> birthdayCells = [];

    birthdayCells.add(
      SpannableGridCellData(
        column: 1,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
        id: "Icon birthday",
        child: Container(
          child: Center(
            child: new Icon(Icons.today, size: iconSize),
          ),
        ),
      ),
    );
    birthdayCells.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "birthday",
        child: Container(
          alignment: Alignment.topLeft,
          child: Center(
              child: new ListTile(
                  leading: new TextButton(
            onPressed: () {
              _selectDate(context);
              print(currentDate);
            },
            child: new Text(
              'Birthday',
              style: new TextStyle(fontSize: 26),
            ),
          ))),
        ),
      ),
    );

    /////////////////////////address//////////////////////////////
    List<SpannableGridCellData> addressCells = [];

    addressCells.add(
      SpannableGridCellData(
        column: 1,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
        id: "Icon house",
        child: Container(
          child: Center(
            child: new Icon(Icons.house, size: iconSize),
          ),
        ),
      ),
    );
    addressCells.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "line one",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      Line One 住所1",
              ),
            ),
          ),
        ),
      ),
    );
    addressCells.add(
      SpannableGridCellData(
        column: 2,
        row: 2,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "line two",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      Line Two 住所2",
              ),
            ),
          ),
        ),
      ),
    );
    addressCells.add(
      SpannableGridCellData(
        column: 2,
        row: 3,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "town",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      Town 町",
              ),
            ),
          ),
        ),
      ),
    );
    addressCells.add(
      SpannableGridCellData(
        column: 2,
        row: 4,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "City",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      City 都市",
              ),
            ),
          ),
        ),
      ),
    );
    addressCells.add(
      SpannableGridCellData(
        column: 2,
        row: 5,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "state",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      State 州",
              ),
            ),
          ),
        ),
      ),
    );
    addressCells.add(
      SpannableGridCellData(
        column: 2,
        row: 6,
        columnSpan: 2,
        rowSpan: 1,
        id: "postcode 郵便番号",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      000",
              ),
            ),
          ),
        ),
      ),
    );
    addressCells.add(
      SpannableGridCellData(
        column: 4,
        row: 6,
        columnSpan: 2,
        rowSpan: 1,
        id: "postcode2",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      0000",
              ),
            ),
          ),
        ),
      ),
    );

    /////////////////////////Bank Account//////////////////////////////
    List<SpannableGridCellData> bankCells = [];

    bankCells.add(
      SpannableGridCellData(
        column: 1,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
        id: "Icon bank",
        child: Container(
          child: Center(
            child: new Icon(Icons.money, size: iconSize),
          ),
        ),
      ),
    );
    bankCells.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "account number",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      Account Number 口座番号",
              ),
            ),
          ),
        ),
      ),
    );
    bankCells.add(
      SpannableGridCellData(
        column: 2,
        row: 2,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "sort code",
        child: Container(
          child: Center(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "      SWIFT code 店番",
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Payment sign up'),
        ),
        body: ModalProgressHUD(
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  SpannableGrid(
                    rowHeight: 50,
                    columns: 5,
                    rows: 4,
                    cells: nameCells,
                    spacing: 2,
                    onCellChanged: (cell) {
                      print('Cell ${cell.id} changed');
                    },
                  ),
                  const Divider(height: 10),
                  SpannableGrid(
                    rowHeight: 45,
                    columns: 5,
                    rows: 2,
                    cells: genderCells,
                    spacing: 1,
                    onCellChanged: (cell) {
                      print('Cell ${cell.id} changed');
                    },
                  ),
                  const Divider(height: 10),
                  SpannableGrid(
                    rowHeight: 50,
                    columns: 5,
                    rows: 1,
                    cells: emailCells,
                    spacing: 1,
                    onCellChanged: (cell) {
                      print('Cell ${cell.id} changed');
                    },
                  ),
                  const Divider(height: 10),
                  SpannableGrid(
                    rowHeight: 50,
                    columns: 5,
                    rows: 1,
                    cells: phoneCells,
                    spacing: 1,
                    onCellChanged: (cell) {
                      print('Cell ${cell.id} changed');
                    },
                  ),
                  const Divider(height: 10),
                  SpannableGrid(
                    rowHeight: 50,
                    columns: 5,
                    rows: 1,
                    cells: birthdayCells,
                    spacing: 0,
                    onCellChanged: (cell) {
                      print('Cell ${cell.id} changed');
                    },
                  ),
                  new Container(
                      height: 50,
                      child:
                          Text('$currentDate', style: TextStyle(fontSize: 20)),
                      alignment: Alignment(-0.31, 0.0)),
                  const Divider(height: 10),
                  SpannableGrid(
                    rowHeight: 50,
                    columns: 5,
                    rows: 6,
                    cells: addressCells,
                    spacing: 1,
                    onCellChanged: (cell) {
                      print('Cell ${cell.id} changed');
                    },
                  ),
                  const Divider(height: 10),
                  SpannableGrid(
                    rowHeight: 50,
                    columns: 5,
                    rows: 2,
                    cells: bankCells,
                    spacing: 1,
                    onCellChanged: (cell) {
                      print('Cell ${cell.id} changed');
                    },
                  ),
                ],
              ),
            ),
            inAsyncCall: _saving,
            color: Colors.deepPurple,
            progressIndicator: CircularProgressIndicator()));
  }
}
