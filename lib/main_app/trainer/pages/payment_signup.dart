import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:skilltrain/main_app/common/headings.dart';
import '../../../utils/gender_selector.dart';
import 'package:spannable_grid/spannable_grid.dart';
import '../../../utils/alert_dialogue.dart';
import '../../common/headings.dart';

class PaymentSignup extends StatefulWidget {
  final List<CognitoUserAttribute> userAttributes;
  final CognitoUser cognitoUser;
  final VoidCallback signUpComplete;
  final bool active;
  PaymentSignup(
      {Key key,
      this.userAttributes,
      this.cognitoUser,
      this.signUpComplete,
      this.active})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _PaymentState();
  }
}

class _PaymentState extends State<PaymentSignup> {
  bool _saving = false;
  String _response;
  String test = '';

  DateTime currenty = DateTime.now();
  String currentDate =
      new DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currenty,
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currenty)
      setState(() {
        currentDate =
            new DateFormat("yyyy-MM-dd").format(pickedDate).toString();
        infoObj['individual']['dob']['year'] = currentDate.substring(0, 5);
        infoObj['individual']['dob']['month'] = currentDate.substring(5, 7);
        infoObj['individual']['dob']['day'] = currentDate.substring(7, 9);
      });
  }

  Map<String, dynamic> priceObj = {"price": 4000};

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
      "first_name_kanji": "Eliot",
      "first_name_kana": "エリオット",
      "last_name_kanji": "Austin-Forbes",
      "last_name_kana": "オースティンフォーブス",
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
    getUsername();
  }

  void getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    infoObj['username'] = username;
    widget.userAttributes.forEach((attribute) {
      if (attribute.getName() == 'email') {
        infoObj['individual']['email'] = attribute.getValue();
      }
    });
  }

  final columnSpan = 4;
  final iconSize = 35.0;

  String postcodeOne;
  String postcodeTwo;

  @override
  Widget build(BuildContext context) {
    void selectedGender(Gender gender) {
      infoObj['individual']['gender'] = gender.actualName;
    }

    GenderSelector _genderSelector =
        new GenderSelector(shouldReturnGender: selectedGender);
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
              onChanged: (text) {
                infoObj['individual']["first_name_kanji"] = text;
              },
              decoration: new InputDecoration(
                hintText: "First Name (Kanji) 名 (漢字)",
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
              onChanged: (text) {
                infoObj['individual']["last_name_kanji"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Last Name (Kanji) 姓 (漢字)",
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
              onChanged: (text) {
                infoObj['individual']["first_name_kana"] = text;
              },
              decoration: new InputDecoration(
                hintText: "First Name (Kana) 名 (カナ)",
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
              onChanged: (text) {
                infoObj['individual']["last_name_kana"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Last Name (Kana) 姓 (カナ)",
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
        columnSpan: 4,
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
        column: 4,
        row: 1,
        columnSpan: columnSpan * 4,
        rowSpan: 2,
        id: "a",
        child: Container(
          child: Center(
            child: _genderSelector,
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
              onChanged: (text) {
                infoObj["email"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Email メールアドレス",
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
              onChanged: (text) {
                infoObj["individual"]["phone"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Phone 電話番号",
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
        columnSpan: 8,
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
        column: 7,
        row: 1,
        columnSpan: 16,
        rowSpan: 1,
        id: "birthday",
        child: new TextButton(
          onPressed: () {
            _selectDate(context);
            print(currentDate);
          },
          child: new Text('  Birthday          ',
              style: new TextStyle(fontSize: 26), textAlign: TextAlign.left),
        ),
      ),
    );

    /////////////////////////address//////////////////////////////
    List<SpannableGridCellData> addressCellsKanji = [];

    addressCellsKanji.add(
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
    addressCellsKanji.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "line one",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                infoObj["individual"]["address_kanji"]["line1"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Line One 住所1 漢字",
              ),
            ),
          ),
        ),
      ),
    );
    addressCellsKanji.add(
      SpannableGridCellData(
        column: 2,
        row: 2,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "line two",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                infoObj["individual"]["address_kanji"]["line2"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Line Two 住所2 漢字",
              ),
            ),
          ),
        ),
      ),
    );
    addressCellsKanji.add(
      SpannableGridCellData(
        column: 2,
        row: 3,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "town",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                infoObj["individual"]["address_kanji"]["town"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Town 町 漢字",
              ),
            ),
          ),
        ),
      ),
    );
    addressCellsKanji.add(
      SpannableGridCellData(
        column: 2,
        row: 4,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "City",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                infoObj["individual"]["address_kanji"]["city"] = text;
              },
              decoration: new InputDecoration(
                hintText: "City 都市 漢字",
              ),
            ),
          ),
        ),
      ),
    );
    addressCellsKanji.add(
      SpannableGridCellData(
        column: 2,
        row: 5,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "state",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                infoObj["individual"]["address_kanji"]["state"] = text;
              },
              decoration: new InputDecoration(
                hintText: "State 州　漢字",
              ),
            ),
          ),
        ),
      ),
    );

    /////////////////////////address kana//////////////////////////////
    List<SpannableGridCellData> addressCellsKana = [];

    addressCellsKana.add(
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
    addressCellsKana.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "line one",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                infoObj["individual"]["address_kana"]["line1"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Line One 住所1 カナ",
              ),
            ),
          ),
        ),
      ),
    );
    addressCellsKana.add(
      SpannableGridCellData(
        column: 2,
        row: 2,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "line two",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                infoObj["individual"]["address_kana"]["line2"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Line Two 住所2 カナ",
              ),
            ),
          ),
        ),
      ),
    );
    addressCellsKana.add(
      SpannableGridCellData(
        column: 2,
        row: 3,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "town",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                infoObj["individual"]["address_kana"]["town"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Town 町 カナ",
              ),
            ),
          ),
        ),
      ),
    );
    addressCellsKana.add(
      SpannableGridCellData(
        column: 2,
        row: 4,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "City",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                infoObj["individual"]["address_kana"]["city"] = text;
              },
              decoration: new InputDecoration(
                hintText: "City 都市 カナ",
              ),
            ),
          ),
        ),
      ),
    );
    addressCellsKana.add(
      SpannableGridCellData(
        column: 2,
        row: 5,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "state",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                infoObj["individual"]["address_kana"]["state"] = text;
              },
              decoration: new InputDecoration(
                hintText: "State 州 カナ",
              ),
            ),
          ),
        ),
      ),
    );
/////////////////////Postcode///////////
    List<SpannableGridCellData> postcode = [];
    postcode.add(
      SpannableGridCellData(
        column: 1,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
        id: "Icon house",
        child: Container(
          child: Center(
            child: new Icon(Icons.local_post_office_rounded, size: iconSize),
          ),
        ),
      ),
    );
    postcode.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
        id: "postcode 郵便番号",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                postcodeOne = text;
              },
              decoration: new InputDecoration(
                hintText: "000",
              ),
            ),
          ),
        ),
      ),
    );
    postcode.add(
      SpannableGridCellData(
        column: 3,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
        id: "postcode2",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                postcodeTwo = text;
              },
              decoration: new InputDecoration(
                hintText: "0000",
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
              onChanged: (text) {
                infoObj["external_account"]["account_number"] = text;
              },
              decoration: new InputDecoration(
                hintText: "Account Number 口座番号",
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
              onChanged: (text) {
                infoObj["external_account"]["routing_number"] = text;
              },
              decoration: new InputDecoration(
                hintText: "SWIFT code 店番",
              ),
            ),
          ),
        ),
      ),
    );
////////////////////////////////////////////////////////////
    List<SpannableGridCellData> priceCells = [];

    priceCells.add(
      SpannableGridCellData(
        column: 1,
        row: 1,
        columnSpan: 1,
        rowSpan: 1,
        id: "Icon bank",
        child: Container(
          child: Center(
            child: new Icon(Icons.attach_money, size: iconSize),
          ),
        ),
      ),
    );
    priceCells.add(
      SpannableGridCellData(
        column: 2,
        row: 1,
        columnSpan: columnSpan,
        rowSpan: 1,
        id: "price per hour",
        child: Container(
          child: Center(
            child: new TextField(
              onChanged: (text) {
                priceObj["price"] = int.parse(text);
              },
              decoration: new InputDecoration(
                hintText: "Price per hour 1時間あたりの価格",
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
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color(0xFFFFFFFF),
          title: Image.asset(
            'assets/icon/icon.png',
            height: 36.0,
            width: 36.0,
          ),
        ),
        body: ModalProgressHUD(
            child: SingleChildScrollView(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          blackHeading(
                              title: "Sign up with ",
                              underline: false,
                              purple: false),
                          blackHeading(
                              title: "Stripe", underline: true, purple: false)
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.purple,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16),
                          child: sectionTitle(title: "Personal Information"),
                        ),
                        Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
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
                                  columns: 20,
                                  rows: 2,
                                  cells: genderCells,
                                  spacing: 1,
                                  onCellChanged: (cell) {
                                    print('Cell ${cell.id} changed');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16),
                          child: sectionTitle(title: "Contact Details"),
                        ),
                        Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
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
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16),
                          child: sectionTitle(title: "Birthday Information"),
                        ),
                        Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                SpannableGrid(
                                  rowHeight: 50,
                                  columns: 40,
                                  rows: 1,
                                  cells: birthdayCells,
                                  spacing: 0,
                                  onCellChanged: (cell) {
                                    print('Cell ${cell.id} changed');
                                  },
                                ),
                                new Container(
                                    height: 50,
                                    child: Text('$currentDate',
                                        style: TextStyle(fontSize: 20)),
                                    alignment: Alignment(-0.46, 0.0)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16),
                          child: sectionTitle(title: "Address Details"),
                        ),
                        Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                SpannableGrid(
                                  rowHeight: 50,
                                  columns: 5,
                                  rows: 5,
                                  cells: addressCellsKanji,
                                  spacing: 1,
                                  onCellChanged: (cell) {
                                    print('Cell ${cell.id} changed');
                                  },
                                ),
                                const Divider(height: 10),
                                SpannableGrid(
                                  rowHeight: 50,
                                  columns: 5,
                                  rows: 5,
                                  cells: addressCellsKana,
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
                                  cells: postcode,
                                  spacing: 1,
                                  onCellChanged: (cell) {
                                    print('Cell ${cell.id} changed');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16),
                          child: sectionTitle(title: "Bank Details"),
                        ),
                        Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: SpannableGrid(
                              rowHeight: 50,
                              columns: 5,
                              rows: 2,
                              cells: bankCells,
                              spacing: 1,
                              onCellChanged: (cell) {
                                print('Cell ${cell.id} changed');
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16),
                          child: sectionTitle(title: "Price per hour"),
                        ),
                        Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: SpannableGrid(
                              rowHeight: 50,
                              columns: 5,
                              rows: 1,
                              cells: priceCells,
                              spacing: 1,
                              onCellChanged: (cell) {
                                print('Cell ${cell.id} changed');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                    ),
                    child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 60,
                        child: RaisedButton(
                          onPressed: !widget.active
                              ? null
                              : () async {
                                  setState(() {
                                    _saving = true;
                                  });
                                  var response = await http.put(
                                      "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/stripe",
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                      },
                                      body: convert.jsonEncode(infoObj));
                                  print(response.statusCode);
                                  print(response.body);
                                  setState(() async {
                                    _saving = false;
                                    if (response.statusCode == 200) {
                                      _response = "Account Created!";
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialogue(
                                                  title: 'Success!',
                                                  content: _response,
                                                  buttonText: 'CLOSE'));
                                      Navigator.pop(context);
                                      widget.signUpComplete();
                                      final List<CognitoUserAttribute>
                                          attributes = [];
                                      attributes.add(new CognitoUserAttribute(
                                          name: 'custom:paymentSigned',
                                          value: 'true'));
                                      try {
                                        final response = await widget
                                            .cognitoUser
                                            .updateAttributes(attributes);
                                        print(response);
                                        // Update the price column of the user
                                        await http.put(
                                          "https://7kkyiipjx5.execute-api.ap-northeast-1.amazonaws.com/api-test/trainers/${infoObj['username']}",
                                          headers: <String, String>{
                                            'Content-Type':
                                                'application/json; charset=UTF-8',
                                          },
                                          body: convert.jsonEncode(priceObj),
                                        );
                                      } catch (e) {
                                        print(
                                            'Failed to add user attribute $e');
                                      }
                                    } else {
                                      final message = response.body.substring(
                                          response.body.indexOf(':') + 1,
                                          response.body.length - 1);
                                      _response = message;
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialogue(
                                                  title: 'Error',
                                                  content: _response,
                                                  buttonText: 'CLOSE'));
                                    }
                                  });
                                  Future.delayed(
                                      const Duration(seconds: 4), () {});
                                },
                          child: Text(
                            widget.active ? "Submit" : "Complete",
                            style: TextStyle(fontSize: 40),
                          ),
                          color: widget.active
                              ? Colors.blueAccent
                              : Colors.lightGreenAccent[400],
                          textColor: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            inAsyncCall: _saving,
            color: Colors.deepPurple,
            progressIndicator: CircularProgressIndicator()));
  }
}
