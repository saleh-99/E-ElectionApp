import 'package:eelection/services/database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../components/rounded_button.dart';
import '../constants.dart';
import 'main_scrreen.dart';

class LoginScreen extends StatefulWidget {
  static String name = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password, error;
  bool showSpinner = false;
  // final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
                child: Text(
                  error ?? '',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputFieldDecoration.copyWith(
                    hintText: 'Username  (student ID)'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputFieldDecoration.copyWith(
                    hintText: 'Password   (Student password)'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  await login();
                  setState(() {
                    showSpinner = false;
                  });
                },
                color: Colors.blueGrey,
                text: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future login() async {
    try {
      await Provider.of<Database>(context, listen: false)
          .getUserData(email, password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } catch (e) {
      print(e);
      setState(() {
        if (e.toString().contains('200'))
          error = 'password is wrong';
        else
          error = 'ID wrong or Server is down';
      });
    }
  }
}
