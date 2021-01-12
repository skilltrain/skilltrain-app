import 'package:flutter/material.dart';
//import './session.dart';

class InstructorBioUpdate extends StatelessWidget {
  int index;
  InstructorBioUpdate({this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("bio update"),
        ),
        body:     
          SingleChildScrollView(
            child:Container(
              child:Column(
              children:<Widget>[
              Container(
                  padding: const EdgeInsets.only(top:8.0, left:8.0, right:8.0 , bottom: 10.0),

            child: Column(
              children: <Widget>[
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(4.0,),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width:3),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white70,
                  ),
                  child: Column(
                      children: <Widget>[
                      Image.asset('assets/images/bio.png',
                      height: 150, fit: BoxFit.fill),
                      Text("Upload portrait",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black54),
                      )                      
                          ],
                  ),
                ),

                Container(
                  width: 300,
                  padding: const EdgeInsets.all(4.0,),
                  margin: const  EdgeInsets.only(top:6.0,),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width:3),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white70,
                  ),
                  child: Column(
                      children: <Widget>[
                      Image.asset('assets/images/bio.png',
                      height: 150, fit: BoxFit.fill),
                      Text("Upload classPhoto",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black54),
                      )                      
                          ],
                  ),
                ),                

                TextFormField(
                  decoration: InputDecoration(labelText: 'genre'),
                ),

                TextFormField(
                  decoration: InputDecoration(labelText: 'price'),
                ),

                TextFormField(
                          decoration: InputDecoration(labelText: 'bio',),
                          maxLines: 4,
                          minLines: 4,
                  ),

                  ]
                )
              ),

                RaisedButton(
                  onPressed: () {
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.pink[300],
                          Colors.purple[500],
                          Colors.purple[700],
                        ],
                      ),
                    ),
                    child: 
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Text('Uodate profile',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              )),
                    )                    
                  ),
                ),

        ]
        ),
        )
      )
    );
  }
}


class ChangeForm extends StatefulWidget {
  @override
  _ChangeFormState createState() => _ChangeFormState();
}

class _ChangeFormState extends State<ChangeForm> {

  String _text = '';

  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: <Widget>[
            Text(
              "$_text",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500
              ),
            ),
            new TextField(
              enabled: true,
              // 入力数
              maxLength: 10,
              maxLengthEnforced: false,
              style: TextStyle(color: Colors.red),
              obscureText: false,
              maxLines:1 ,
              //パスワード
              onChanged: _handleText,
            ),
          ],
        )
    );
  }
}