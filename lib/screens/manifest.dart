import 'package:eelection/models/modals.dart';
import 'package:eelection/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/item_manifest.dart';
import '../constants.dart';

class ManifestScreen extends StatefulWidget {
  final page;
  const ManifestScreen({Key key, this.page}) : super(key: key);
  @override
  _ManifestScreenState createState() => _ManifestScreenState();
}

class _ManifestScreenState extends State<ManifestScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<Database>(context).currentUser;
    final orientation = MediaQuery.of(context).orientation;
    super.build(context);
    return StreamProvider<List<Manifests>>.value(
      value: Database().getManifestsList(widget.page == 'manifest_department'
          ? currentUser.departmentName
          : 'Hashemite University'),
      initialData: [],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(
              '${widget.page == 'manifest_department' ? currentUser.departmentName : 'Hashemite University'}',
              style: kDepartmentName,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Consumer<List<Manifests>>(
              builder: (_, List<Manifests> manifests, w) {
                if (manifests != null) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 3),
                    itemCount: manifests.length,
                    itemBuilder: (_, int index) {
                      return ItemManifest(
                          element: manifests[index], page: widget.page);
                    },
                  );
                }
                return Text('loading');
              },
            ),
          ),
        ],
      ),
    );
  }
}
