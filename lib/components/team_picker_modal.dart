import 'package:eelection/components/team_picker_item.dart';
import 'package:eelection/components/wide_button.dart';
import 'package:eelection/models/current_user.dart';
import 'package:eelection/models/modals.dart';
import 'package:eelection/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

/// Present a list of [Candidates]s for the student to choose from.
class TeamPickerModal extends StatefulWidget {
  final Manifests element;
  final CurrentUser currentUser;
  final page;

  const TeamPickerModal({Key key, this.element, this.currentUser, this.page})
      : super(key: key);
  @override
  TeamPickerModalState createState() {
    return currentUser.mapManifest['Manifestdepartment']['Name'] == element.name
        ? TeamPickerModalState(
            currentUser.mapManifest['Manifestdepartment']['Candidates'])
        : TeamPickerModalState(<Candidate>[]);
  }
}

class TeamPickerModalState extends State<TeamPickerModal> {
  final Set<Candidate> _selected;

  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: 15);

  TeamPickerModalState(Iterable<Candidate> initialTeam)
      : _selected = Set<Candidate>.from(initialTeam ?? <Candidate>[]);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<Database>(context).currentUser;
    var isUnassigning = (currentUser
                .mapManifest['Manifestdepartment']['Candidates']?.isNotEmpty ??
            false) &&
        _selected.isEmpty;
    var isButtonDisabled = false;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Container(
        color: modalBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Center(
                child: Text(
              widget.element.name,
              style: contentLargeStyle,
            )),
            const SizedBox(height: 15),
            Padding(
              padding: horizontalPadding,
              child: Text('Candidates :',
                  style: buttonTextStyle.apply(
                      fontSizeDelta: -4, color: secondaryContentColor)),
            ),
            const SizedBox(height: 7),
            Expanded(
              child: StreamBuilder<List<Candidate>>(
                  stream: Provider.of<Database>(context).getCandidateList(
                      widget.element.iD,
                      widget.page == "manifest_department"
                          ? currentUser.departmentName
                          : "Hashemite University"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var candidates = snapshot.data;
                      return ListView.builder(
                          itemCount: candidates.length,
                          padding: horizontalPadding,
                          itemBuilder: (context, index) {
                            var candidate = candidates[index];
                            return TeamPickerItem(
                              candidate: candidate,
                              isSelected: iscontains(candidate),
                              toggleSelection: _toggleCharacterSelected,
                              isDisabled: currentUser.isVoted,
                            );
                          });
                    }
                    return Center(
                      child: Text(
                        'Lodding Canddiets '
                        'Or Bad Network',
                        style: contentLargeStyle,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),
            ),
            Padding(
              padding: horizontalPadding.add(
                EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 15),
              ),
              child: WideButton(
                onPressed: () async {
                  currentUser.addManifestdepartment(widget.element.name);
                  currentUser.setCandidatesdepartment(_selected.toList());
                  Provider.of<Database>(context, listen: false).createRecord(
                      widget.page == "manifest_department"
                          ? "Manifestdepartment"
                          : "ManifestCollage");
                  Navigator.pop(context);
                },
                paddingTweak: const EdgeInsets.only(right: -7),
                background: isButtonDisabled
                    ? contentColor.withOpacity(0.1)
                    : const Color.fromRGBO(84, 114, 239, 1),
                child: Text(
                  isUnassigning ? 'UNASSIGN Candidates' : 'ASSIGN Candidates',
                  style: buttonTextStyle.apply(
                    color: isButtonDisabled
                        ? contentColor.withOpacity(0.25)
                        : Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _toggleCharacterSelected(Candidate candidate, bool selected) {
    final currentUser =
        Provider.of<Database>(context, listen: false).currentUser;
    if (currentUser.id == candidate.id) {
      return;
    }
    setState(() {
      if (selected) {
        _selected.add(candidate);
      } else {
        Candidate c;
        _selected.forEach((element) {
          if (element.id == candidate.id) {
            c = element;
            return;
          }
        });
        _selected.remove(c);
      }
    });
  }

  bool iscontains(Candidate candidate) {
    bool check = false;
    _selected.forEach((element) {
      if (element.id == candidate.id) {
        check = true;
        return;
      }
    });
    return check;
  }
}
