import 'dart:io';

import 'package:eelection/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  String userName = '';

  File _imageFile;
  @override
  bool get wantKeepAlive => true;

  TextEditingController userNameController = TextEditingController();
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentUser = Provider.of<Database>(context).currentUser;
    userNameController.text = currentUser.later;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: CircleAvatar(
              radius: 78,
              backgroundColor: _imageFile != null ? Colors.red : Colors.white,
              child: CircleAvatar(
                radius: 75,
                backgroundImage: _imageFile != null
                    ? AssetImage(_imageFile.path)
                    : NetworkImage(currentUser.imageUrl),
              ),
            ),
          ),
          Text(
            currentUser.name,
            style: TextStyle(fontSize: 40, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          currentUser.isCandidate
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          maxLines: 4,
                          onChanged: (newLater) {
                            currentUser.later = newLater;
                          },
                          controller: userNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 1.0),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: "Text")),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              chooseFile();
                            });
                          },
                          child: Container(
                            color: Colors.blueGrey,
                            height: 40,
                            child: Center(
                              child: Text(
                                " Choose Image ",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Provider.of<Database>(context, listen: false)
                                .editeprofile(
                                    _imageFile, userNameController.text);
                            setState(() {
                              _imageFile = null;
                            });
                          },
                          child: Container(
                            color: Colors.blueGrey,
                            height: 40,
                            child: Center(
                              child: Text(
                                " Edit profile ",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : Container(),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  chooseFile() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
}
