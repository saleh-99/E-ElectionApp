import 'package:eelection/models/modals.dart';
import 'package:eelection/screens/login_screen.dart';
import 'package:eelection/screens/welcome_screen.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Eelection());
}
// fitied box

class Eelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        StreamProvider<Time>.value(
          value: Database().getTime(),
          initialData: null,
        ),
        Provider<Database>(
          create: (_) => Database(),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: WelcomeScreen.name,
          routes: {
            LoginScreen.name: (context) => LoginScreen(),
            WelcomeScreen.name: (context) => WelcomeScreen(),
          }),
    );
  }
}
