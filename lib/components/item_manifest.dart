import 'dart:io';
import 'dart:typed_data';

import 'package:eelection/screens/candidates_select_screen.dart';
import 'package:eelection/services/database.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/modals.dart';
import 'focused_menu.dart';

class ItemManifest extends StatelessWidget {
  final Manifests element;
  final page;

  const ItemManifest({
    this.element,
    Key key,
    this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<Database>(context).currentUser;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FocusedMenuHolder(
        onPressed: () {
          _showModal(context, element: element, page: page);
        },
        menuWidth: MediaQuery.of(context).size.width * 0.50,
        blurSize: 5.0,
        menuItemExtent: 45,
        menuOffset: 5,
        menuBoxDecoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: Duration(milliseconds: 200),
        animateMenuItems: false,
        blurBackgroundColor: Colors.black45,
        bottomOffsetHeight: 80,
        menuItems: <FocusedMenuItem>[
          FocusedMenuItem(
              title: Text("Open"),
              trailingIcon: Icon(Icons.open_in_full),
              onPressed: () {
                _showModal(context, element: element, page: page);
              }),
          FocusedMenuItem(
              title: Text("Share"),
              trailingIcon: Icon(Icons.share),
              onPressed: () async {
                var request = await HttpClient().getUrl(Uri.parse(
                    'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=${currentUser.departmentName + "//" + element.iD}'));
                var response = await request.close();
                Uint8List bytes =
                    await consolidateHttpClientResponseBytes(response);
                await Share.file(
                    'E-Elction', '${element.iD}.png', bytes, 'image/png');
              }),
          FocusedMenuItem(
              title: Text("Add to favourite"),
              trailingIcon: Icon(Icons.add_box_outlined),
              onPressed: () {
                currentUser.addToF(element.name);
              }),
        ],
        child: Container(
          decoration: kBoxDecoration.copyWith(boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.5),
              spreadRadius: 6,
              blurRadius: 7,
              offset: Offset(0, 6), // changes position of shadow
            ),
          ]),
          child: GridTile(
            header: Text(
              '${element.iD}',
              style: kManfiestName,
              textAlign: TextAlign.center,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: (element.image != '')
                  ? FittedBox(child: Image.network('${element.image}'))
                  : SizedBox(
                      height: 10,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _showModal(BuildContext context, {Manifests element, page}) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CandidatesSelectScreen(element: element, page: page);
        });
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             CandidatesSelectScreen(element: element, page: page)));
  }
}
