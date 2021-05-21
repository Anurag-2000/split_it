import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:split_it/dashboard/dashboard.dart';
import 'package:split_it/database/database.dart';
import 'package:split_it/login/initial.dart';
import 'package:split_it/login/loginPage.dart';
import 'package:split_it/models/contactList.dart';
import 'package:split_it/models/userData.dart';

import 'database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
          create: (context) => DatabaseService().getUserDataStream(),
          initialData: UserData.empty(),
        ),
        ChangeNotifierProvider(create: (_) => ContactList())
      ],
      child: MaterialApp(
          title: 'Split It',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: CheckUserStatus()),
    );
  }
}

class CheckUserStatus extends StatefulWidget {
  CheckUserStatus({Key key}) : super(key: key);

  @override
  _CheckUserStatusState createState() => _CheckUserStatusState();
}

class _CheckUserStatusState extends State<CheckUserStatus> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkSignIn(),
        builder: (context, snapshot) {
          var page;
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case "login":
                {
                  page = LoginPage();
                  break;
                }
              case "home":
                {
                  page = Dashboard();
                  break;
                }
              case "initial":
                {
                  page = InitialDetailPage();
                  break;
                }
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: page,
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Future<String> checkSignIn() async {
    if (FirebaseAuth.instance.currentUser == null)
      return "login";
    else if (!(await DatabaseService().isUserDocExists()))
      return "initial";
    else
      return "home";
  }
}
