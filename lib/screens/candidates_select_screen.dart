import 'package:eelection/components/team_picker_modal.dart';
import 'package:eelection/models/modals.dart';
import 'package:eelection/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CandidatesSelectScreen extends StatefulWidget {
  const CandidatesSelectScreen({this.element, this.page});

  @override
  _CandidatesSelectScreenState createState() => _CandidatesSelectScreenState();
  final Manifests element;
  final page;
}

class _CandidatesSelectScreenState extends State<CandidatesSelectScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<Database>(context).currentUser;
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 40),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Image.network(
                        widget.element.image,
                        fit: BoxFit.scaleDown,
                        height: 250,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ButtonTheme(
                      minWidth: 0,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: const Icon(
                          Icons.cancel,
                          color: Colors.black87,
                          semanticLabel: "Close",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TeamPickerModal(
                        element: widget.element,
                        page: widget.page,
                        currentUser: currentUser,
                      ),
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
