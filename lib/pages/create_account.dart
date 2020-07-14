import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat_app/pages/home.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  String username;
  String challengeID;
  submit() {
    final form = _formKey.currentState;
    final form1 = _formKey1.currentState;

    if (form.validate() && form1.validate()) {
      form.save() ;
      form1.save();
      SnackBar snackbar = SnackBar(
        content: Text("Welcome $username!"),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
//        Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.only(top: 25),
//                  child: Center(
//                    child: Text(
//                      "Create a username",
//                      style: TextStyle(fontSize: 25),
//                    ),
//                  ),
//                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 3 || val.isEmpty) {
                            return "username too short";
                          } else if (val.trim().length > 12) {
                            return "username too long";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) => username = val,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            labelStyle: TextStyle(fontSize: 15),
                            hintText: "Must be atleast 3 characters"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    child: Form(
                      key: _formKey1,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 7 || val.isEmpty) {
                            return "username too short";
                          } else if (val.trim().length > 12) {
                            return "username too long";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) => challengeID = val,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "ChallengeId",
                            labelStyle: TextStyle(fontSize: 15),
                            hintText: "Must be atleast 7 characters"),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
