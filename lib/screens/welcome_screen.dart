import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eelection/components/count_timer_box.dart';
import "package:eelection/components/rounded_button.dart";
import 'package:eelection/models/modals.dart';
import 'package:eelection/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String name = 'WelcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 200.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: 250.0,
                    height: 100.0,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Student Council \n E-elections",
                          textStyle: kAppNameTextStyle,
                          textAlign: TextAlign.center,
                          speed: const Duration(milliseconds: 200),
                        ),
                      ],
                      totalRepeatCount: 4,
                      pause: const Duration(milliseconds: 1000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    )),
              ),
              Material(
                elevation: 10.0,
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(30.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Consumer<Time>(builder: (_, Time time, w) {
                    try {
                      if (time.start != null || time.end != null) {
                        return CountDownTimer(
                          timeFromData: time,
                        );
                      }
                    } catch (e) {}

                    return Text(
                      'Lodding, OR no election',
                      textAlign: TextAlign.center,
                      style: kTimeNumber,
                    );
                  }),
                ),
              ),
              Expanded(
                flex: 5,
                child: SizedBox(),
              ),
              RoundedButton(
                horizontal: 100.0,
                text: '->',
                onPressed: () async {
                  if (await Provider.of<Database>(context, listen: false)
                      .getTime()
                      .first
                      .then((value) => value.endVoting()))
                    Navigator.pushNamed(
                      context,
                      LoginScreen.name,
                    );
                },
                color: Colors.blueGrey,
              ),
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
