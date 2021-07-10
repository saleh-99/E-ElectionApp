import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eelection/models/current_user.dart';
import 'package:eelection/models/modals.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class Database {
  final _cloudfirestore = FirebaseFirestore.instance;
  var downloadUrl;
  CurrentUser _currentUser;
  Time time;
  CurrentUser get currentUser {
    return _currentUser;
  }

  Stream<List<Manifests>> getManifestsList(String departmentName) {
    return _cloudfirestore
        .collection('Collage')
        .doc(departmentName)
        .collection('Manifiest')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) => Manifests.fromFirestore(document))
            .toList());
  }

  Stream<List<Candidate>> getCandidateList(
      String manifestsID, String departmentName) {
    return _cloudfirestore
        .collection('Collage')
        .doc(departmentName)
        .collection('Manifiest')
        .doc(manifestsID)
        .collection('Candidates')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) => Candidate.fromFirestore(document))
            .toList());
  }

  Stream<Time> getTime() {
    return _cloudfirestore
        .collection('Config')
        .doc("Date")
        .snapshots()
        .map((snapShot) {
      if (snapShot.exists)
        time = Time.fromFirestore(snapShot);
      else
        time = null;
      return time;
    });
  }

  Future<Manifests> getSingleManifest(
      String manifestsID, String departmentName) async {
    return await _cloudfirestore
        .collection('Collage')
        .doc(departmentName)
        .collection('Manifiest')
        .doc(manifestsID)
        .get()
        .then((value) => Manifests.fromFirestore(value));
  }

  // TODO: not working in Hashemite University
  Future editeprofile(File imageFile, String later) async {
    if (imageFile != null) {
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('images/${currentUser.id}')
          .putFile(imageFile);

      downloadUrl = await snapshot.ref.getDownloadURL();
    } else {
      downloadUrl = null;
    }
    currentUser.later = later == "" ? currentUser.later : later;
    currentUser.imageUrl =
        downloadUrl == null ? currentUser.imageUrl : downloadUrl.toString();
    await _cloudfirestore
        .collection('Collage')
        .doc(currentUser.departmentName)
        .collection('Manifiest')
        .doc(currentUser.candidateManifest)
        .collection('Candidates')
        .doc(currentUser.id)
        .update({
      "Image": currentUser.imageUrl,
      "Later": currentUser.later
    }).then((result) {
      print("update done");
    }).catchError((onError) {
      print("onError");
    });
  }

  void createRecord(String departmentName) async {
    List<Map> d = <Map>[];
    currentUser.mapManifest[departmentName]['Candidates'].forEach((element) {
      d.add({
        "ID": element.id,
        "image": element.image,
        "later": element.later,
        "name": element.name
      });
    });
    Map<String, dynamic> m = {
      "ManifestName": currentUser.mapManifest[departmentName]["Name"],
      "ID": currentUser.id,
      "Candidates": d
    };
    await _cloudfirestore
        .collection('Collage')
        .doc(departmentName == "Manifestdepartment"
            ? currentUser.departmentName
            : "Hashemite University")
        .collection('Student')
        .doc(currentUser.id)
        .set(m);
  }

  Future getUserData(String id, String pass) async {
    http.Response response = await http
        .get('https://e-election-e4023.firebaseio.com/Student/$id.json');
    if (response.statusCode == 200 &&
        jsonDecode(response.body) != null &&
        jsonDecode(response.body)["Password"].toString() == pass) {
      String data = response.body;
      _currentUser = CurrentUser.fromMap(jsonDecode(data));
      chekingisercanddite();
      getprevotinglist(currentUser.departmentName);
      getprevotinglist("Hashemite University");
      return jsonDecode(data);
    } else {
      throw (response.statusCode);
    }
  }

  Future<void> getprevotinglist(String departmentName) async {
    await _cloudfirestore
        .collection('Collage')
        .doc(departmentName)
        .collection("Student")
        .doc(currentUser.id)
        .get()
        .then((value) {
      if (value.exists) {
        currentUser.mapManifest[departmentName == currentUser.departmentName
            ? "Manifestdepartment"
            : "ManifestCollage"]["Name"] = value.data()["ManifestName"];

        currentUser.isVoted = value.data()["IsVoting"];

        List<Candidate> c = <Candidate>[];
        value.data()["Candidates"].forEach((element) {
          Candidate candidate = Candidate(
              id: element["ID"],
              name: element["name"],
              image: element["image"],
              later: element["later"]);
          c.add(candidate);
        });
        currentUser.mapManifest[departmentName == currentUser.departmentName
            ? "Manifestdepartment"
            : "ManifestCollage"]['Candidates'] = c;
      }
    }).catchError((error) => print("Failed to GetPreVoting: $error"));
  }

  Future<void> voting(String departmentName) async {
    // Department
    await _cloudfirestore
        .collection('Collage')
        .doc(departmentName == 'Manifestdepartment'
            ? currentUser.departmentName
            : "Hashemite University")
        .update({'N': FieldValue.increment(1)})
        .then((value) => print("done_departmentName"))
        .catchError((error) => print("Failed to update user: $error"));

    // Manifest
    await _cloudfirestore
        .collection('Collage')
        .doc(departmentName == 'Manifestdepartment'
            ? currentUser.departmentName
            : "Hashemite University")
        .collection('Manifiest')
        .doc(currentUser.mapManifest["Manifestdepartment"]["Name"])
        .update({'N': FieldValue.increment(1)})
        .then((value) => print("done_Manifestdepartment"))
        .catchError((error) => print("Failed to update user: $error"));

    // candidate
    await _cloudfirestore
        .collection('Collage')
        .doc(departmentName == 'Manifestdepartment'
            ? currentUser.departmentName
            : "Hashemite University")
        .collection('Manifiest')
        .doc(currentUser.mapManifest["Manifestdepartment"]["Name"])
        .collection('Candidates')
        .where("ID", whereIn: currentUser.getCandidateID())
        .get()
        .then((value) {
      var batch = _cloudfirestore.batch();
      value.docs.forEach((element) {
        var docRef = _cloudfirestore
            .collection('Collage')
            .doc(departmentName == 'Manifestdepartment'
                ? currentUser.departmentName
                : "Hashemite University")
            .collection('Manifiest')
            .doc(currentUser.mapManifest[departmentName]["Name"])
            .collection('Candidates')
            .doc(element.id);
        batch.update(docRef, {"N": FieldValue.increment(1)});
      });
      batch.commit().then((value) {
        print("updated all done");
      });
    }).catchError((error) => print("Failed to update user: $error"));

    currentUser.isVoted = true;
  }

  Future<void> chekingisercanddite() async {
    String m;
    await _cloudfirestore
        .collection('Collage')
        .doc(currentUser.departmentName)
        .collection('Manifiest')
        .get()
        .then((value) => value.docs.forEach((element) async {
              await _cloudfirestore
                  .collection('Collage')
                  .doc(currentUser.departmentName)
                  .collection('Manifiest')
                  .doc(element.id)
                  .collection('Candidates')
                  .where("ID", isEqualTo: int.parse(currentUser.id))
                  .get()
                  .then((value) {
                if (value.docs.isNotEmpty) {
                  m = element.id;
                  currentUser.imageUrl = value.docs.first.data()["Image"] == ""
                      ? currentUser.imageUrl
                      : value.docs.first.data()["Image"];
                  currentUser.later = value.docs.first.data()["Later"];
                  currentUser.isCandidate = true;
                  currentUser.candidateManifest = m;
                }
              });
            }));
  }
}
