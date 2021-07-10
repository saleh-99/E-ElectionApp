import 'package:eelection/models/modals.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class TeamPickerItem extends StatelessWidget {
  final Candidate candidate;
  final bool isSelected;
  final bool isDisabled;
  final void Function(Candidate candidate, bool selected) toggleSelection;

  static const Duration animationDuration = Duration(milliseconds: 175);
  const TeamPickerItem(
      {this.isSelected = false,
      this.toggleSelection,
      this.isDisabled,
      this.candidate});

  @override
  Widget build(BuildContext context) {
    var backgroundColor = isDisabled
        ? disabledColor
        : isSelected
            ? const Color.fromRGBO(84, 114, 239, 1)
            : const Color.fromRGBO(69, 69, 82, 1);
    return AnimatedPadding(
      padding: isSelected
          ? const EdgeInsets.only(top: 7, bottom: 30)
          : const EdgeInsets.only(top: 27, bottom: 10),
      duration: animationDuration,
      curve: Curves.easeInOut,
      child: InkWell(
        key: Key(candidate.id),
        onLongPress: () {
          showCandidate(context);
        },
        onTap: () =>
            isDisabled ? null : toggleSelection(candidate, !isSelected),
        child: Padding(
          padding: const EdgeInsets.only(right: 0),
          child: AnimatedContainer(
            duration: animationDuration,
            width: 130,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: isSelected && !isDisabled
                        ? const Color.fromRGBO(26, 50, 155, 0.3)
                        : Colors.black.withOpacity(0.17),
                    offset: const Offset(0, 10),
                    blurRadius: isSelected ? 30 : 10),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: backgroundColor,
            ),
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(candidate.image),
                    ),
                  ),
                  const SizedBox(height: 29),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidate.name,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Container(
                        width: 200,
                        child: Text(
                          candidate.later,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showCandidate(BuildContext context) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 30, bottom: 30),
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              candidate.image,
                              fit: BoxFit.fill,
                              height: 300,
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
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    candidate.name,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  const Divider(
                                    height: 20,
                                    thickness: 5,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                  Text(
                                    candidate.later,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
            ),
          );
        });
  }
}
