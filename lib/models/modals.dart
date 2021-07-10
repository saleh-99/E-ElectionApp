import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FocusedMenuItem {
  Color backgroundColor;
  Widget title;
  Icon trailingIcon;
  Function onPressed;

  FocusedMenuItem(
      {this.backgroundColor,
      @required this.title,
      this.trailingIcon,
      @required this.onPressed});
}

class Manifests {
  final name;
  final iD;
  final image;
  List<Candidate> candidate = [];

  Manifests({this.name, this.iD, this.image});

  factory Manifests.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Manifests(
        name: data['Name'] ?? 'HU',
        iD: doc.id ?? 'NO Name',
        image: data['Image'] ?? 'HU image');
  }
}

class Candidate {
  final id;
  final name;
  final image;
  final later;

  Candidate({this.name, this.id, this.image, this.later});

  factory Candidate.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Candidate(
      id: doc.id,
      image: data['Image'] == ""
          ? 'https://tekrabuilders.com/wp-content/uploads/2018/12/male-placeholder-image.jpeg'
          : data['Image'],
      name: data['Name'] ?? 'No Name',
      later: data['Later'] ?? ' ',
    );
  }
}

class Time {
  final Timestamp start;
  final Timestamp end;

  Time({this.start, this.end});

  factory Time.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Time(start: data['StartDate'], end: data['EndDate']);
  }
  bool startOrEnd() {
    return (start.millisecondsSinceEpoch >
        DateTime.now().millisecondsSinceEpoch + 200);
  }

  bool endVoting() {
    return (end.millisecondsSinceEpoch >
        DateTime.now().millisecondsSinceEpoch + 100);
  }
}
