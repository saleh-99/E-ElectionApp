import 'package:eelection/components/bottom_navigation.dart';
import 'package:eelection/components/rounded_button.dart';
import 'package:eelection/models/animated-modal.dart';
import 'package:eelection/models/current_user.dart';
import 'package:eelection/models/modals.dart';
import 'package:eelection/screens/candidates_select_screen.dart';
import 'package:eelection/screens/welcome_screen.dart';
import 'package:eelection/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'manifest.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  static String name = 'MainScreen';
  const MainScreen({Key key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _controller = PageController();
  _MainScreenState() {
    _controller.addListener(() {
      if (_controller.page.round() != _currentIndex) {
        setState(() {
          _currentIndex = _controller.page.round();
        });
      }
    });
  }

  int _currentIndex = 0;
  String _currentPage = "manifest_department";

  List<String> pageKeys = [
    "manifest_department",
    "manifest_collage",
    "profile_screen1",
    "profile_screen",
  ];
  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "manifest_department": GlobalKey<NavigatorState>(),
    "manifest_collage": GlobalKey<NavigatorState>(),
    "profile_screen1": GlobalKey<NavigatorState>(),
    "profile_screen": GlobalKey<NavigatorState>(),
  };

  void _showPageIndex(int index) {
    setState(() {
      _currentPage = pageKeys[index];
      _currentIndex = index;
    });
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutCubic,
    );
  }

  void _selectTab(String tabItem, int index) {
    _showPageIndex(index);
  }

  void _logout() {
    Navigator.popUntil(context, ModalRoute.withName(WelcomeScreen.name));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final currentUser = Provider.of<Database>(context).currentUser;
    return WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab = _currentIndex != 0;
          if (isFirstRouteInCurrentTab) {
            if (_currentPage != "manifest_department") {
              _selectTab("manifest_department", 0);
              return false;
            }
          }
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Image.asset(
                    'images/qrcodescan_120401.png',
                    height: 25.0,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    String barcodeScanRes =
                        await FlutterBarcodeScanner.scanBarcode(
                            "#ff6666", "Cancel", false, ScanMode.QR);

                    if (barcodeScanRes.split("//")[0] !=
                            currentUser.departmentName ||
                        barcodeScanRes.split("//")[0] != "Hashemite University")
                      return;
                    _showModal(
                      context,
                      element:
                          await Provider.of<Database>(context, listen: false)
                              .getSingleManifest(barcodeScanRes.split("//")[1],
                                  barcodeScanRes.split("//")[0]),
                    );
                  }),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _logout();
                  }),
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 25.0,
                      child: Image.asset(
                        'images/logo.png',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    " Student E-Elections",
                    overflow: TextOverflow.ellipsis,
                    style: kAppName,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.blueGrey,
          ),
          body: Stack(children: <Widget>[
            PageView(
                controller: _controller,
                onPageChanged: _showPageIndex,
                children: [
                  Navigator(
                    key: _navigatorKeys['manifest_department'],
                    onGenerateRoute: (routeSettings) {
                      return MaterialPageRoute(
                          builder: (context) => ManifestScreen(
                                page: 'manifest_department',
                              ));
                    },
                  ),
                  Navigator(
                    key: _navigatorKeys['manifest_collage'],
                    onGenerateRoute: (routeSettings) {
                      return MaterialPageRoute(
                          builder: (context) => ManifestScreen());
                    },
                  ),
                  Container(),
                  ProfileScreen(
                    key: _navigatorKeys['profile_screen'],
                  ),
                ]),
            Positioned(
              left: 0,
              bottom: 0,
              child: BottomNavigation(
                size: size,
                currentIndex: _currentIndex,
                onPressedFloat: () {
                  displayBottomSheet(context, currentUser);
                },
                onPressedicon0: () {
                  _selectTab(pageKeys[0], 0);
                },
                onPressedicon1: () {
                  _selectTab(pageKeys[1], 1);
                },
                onPressedicon2: () {
                  _selectTab(pageKeys[2], 2);
                },
                onPressedicon3: () {
                  _selectTab(pageKeys[3], 3);
                },
              ),
            ),
          ]),
        ));
  }

  void _showModal(BuildContext context, {Manifests element}) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CandidatesSelectScreen(element: element);
        });
  }

  void displayBottomSheet(BuildContext context, CurrentUser currentUser) {
    if (_currentIndex > 1) {
      return;
    }
    String department;
    if (_currentIndex == 0) {
      department = 'Manifestdepartment';
    } else {
      department = "ManifestCollage";
    }
    if (currentUser.mapManifest[department]['Candidates'].isEmpty) return;
    List<Candidate> selectedCandidate =
        currentUser.mapManifest[department]['Candidates'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 20,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * .7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  currentUser.mapManifest[department]['Name'],
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: selectedCandidate.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: 15, right: 15, bottom: 10),
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          elevation: 10,
                          child: SizedBox(
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                      selectedCandidate[index].image,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 29),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedCandidate[index].name ?? " ",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    Text(
                                      selectedCandidate[index].later ?? " ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              RoundedButton(
                text: 'Confirm',
                color: Colors.red,
                onPressed: _showSuccessVoting,
              ),
              SizedBox(
                height: 15.0,
              )
            ],
          ),
        );
      },
    );
  }

  _showSuccessVoting() {
    showDialog(
        context: context,
        builder: (_) {
          return Center(
            child: CheckAnimation(
              size: 100,
              onComplete: () {
                String department;
                if (_currentIndex == 0) {
                  department = 'Manifestdepartment';
                } else {
                  department = "ManifestCollage";
                }
                Provider.of<Database>(context, listen: false)
                    .voting(department);
              },
            ),
          );
        });
  }
}
