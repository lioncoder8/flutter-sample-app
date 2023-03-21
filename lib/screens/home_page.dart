import 'package:dyte_flutter_sample_app/screens/base_page.dart';
import 'package:dyte_flutter_sample_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DyteSampleHomePage extends StatefulWidget {
  const DyteSampleHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DyteSampleHomePage> createState() => _DyteSampleHomePageState();
}

//This is the home page containing three buttons of group call, webinar and custom controls. It's a supporting file and contains no important logic code. For seeing create meeting and join meeting logic you can directly skip to the pages: lib/screens/create_meeting.dart and lib/screens/join_meeting.dart(If you are skipping to these files checkout mode enum here)
class _DyteSampleHomePageState extends State<DyteSampleHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xff2160fd),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(25),
              child: TextButton(
                child: const Text(
                  'Group Call',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BasePage(
                              //Note: Check this mode
                              mode: Mode.groupCall,
                              title: '${widget.title} - Group Call')));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25),
              child: TextButton(
                child: const Text(
                  'Webinar',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BasePage(
                              //Note: Check this mode
                              mode: Mode.webinar,
                              title: '${widget.title} - Webinar')));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25),
              child: TextButton(
                child: const Text(
                  'Custom Controls',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BasePage(
                              //Note: Check this mode
                              mode: Mode.customControls,
                              title: '${widget.title} - Custom Controls')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
