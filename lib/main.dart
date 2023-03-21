import 'package:dyte_flutter_sample_app/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DyteSampleApp());
}

//This is a sample app showcasing usage of dyte flutter sdk
//To install the sdk: https://docs.dyte.io/flutter/installation
//And getting quickstarted on it: https://docs.dyte.io/flutter/quickstart
//If you want to see SDK usage directly you can check file: lib/screens/dyte_meeting_page.dart
class DyteSampleApp extends StatelessWidget {
  const DyteSampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dyte Sample App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xff2160fd),
              primary: const Color(0xfff5f5f7),
            ),
          ),
          scaffoldBackgroundColor: const Color(0xff060617)),
      home: const DyteSampleHomePage(title: 'Dyte Sample App'),
      debugShowCheckedModeBanner: false,
    );
  }
}
