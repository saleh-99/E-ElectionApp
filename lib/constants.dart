import 'package:flutter/material.dart';

const Color contentColor = Color.fromRGBO(38, 38, 47, 1);
const Color disabledColor = Color.fromRGBO(116, 116, 126, 1);
const Color modalBackgroundColor = Color.fromRGBO(241, 241, 241, 1);
const Color secondaryContentColor = Color.fromRGBO(111, 111, 118, 1);

const double modalMaxWidth = 400;
const double ultraWideLayoutThreshold = 1920;
const double wideLayoutThreshold = 800;

const kInputFieldDecoration = InputDecoration(
  hintText: 'Enter your email',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10)),
);

const kDepartmentName = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
);
const kAppName = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

const kManfiestName = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 30.0,
  color: Colors.black,
);

const kCountFinsh = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const KBoxShadowTime = BoxShadow(
  color: Colors.black12,
  blurRadius: 5.0,
  spreadRadius: 0.0,
  offset: Offset(-5.0, 2.0),
);

const kTimeDot = TextStyle(
  fontSize: 30,
  color: Colors.white,
);
const KTimeText = TextStyle(
  fontSize: 10,
  color: Colors.white,
);

const kTimeNumber = TextStyle(
  fontSize: 20.0,
  color: Colors.white,
);
const kAppNameTextStyle = TextStyle(
  fontSize: 40.0,
  fontFamily: "Agne",
  fontWeight: FontWeight.w900,
  color: Colors.black,
);
const TextStyle buttonTextStyle = TextStyle(
  fontFamily: 'MontserratMedium',
  fontSize: 16,
  color: Color.fromRGBO(38, 38, 47, 1),
);

const TextStyle contentLargeStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontFamily: 'MontserratRegular',
  fontSize: 24,
  color: contentColor,
);
