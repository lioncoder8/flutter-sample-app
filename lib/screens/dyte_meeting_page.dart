// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dyte_client/dyteMeeting.dart';
import 'package:dyte_flutter_sample_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dyte_client/dyte.dart';
import 'package:dyte_client/dyteParticipant.dart';

class DyteMeetingPage extends StatefulWidget {
  final String roomName;
  final String authToken;
  final Mode mode;

  const DyteMeetingPage({
    Key? key,
    @required required this.roomName,
    @required required this.authToken,
    @required required this.mode,
  }) : super(key: key);

  @override
  _DyteMeetingPageState createState() => _DyteMeetingPageState();
}

//Quickstart on usage of SDK: https://docs.dyte.io/flutter/quickstart
class _DyteMeetingPageState extends State<DyteMeetingPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Row(
        children: <Widget>[
          SizedBox(
            width: width,
            height: height,
            child: DyteMeeting(
              roomName: widget.roomName,
              authToken: widget.authToken,
              onInit: (DyteMeetingHandler meeting) async {
                if (widget.mode == Mode.customControls) {
                  //Here we are trying to change meeting's UI check this page for detailed documentation: https://docs.dyte.io/flutter/customize-meeting-ui and https://docs.dyte.io/flutter/advanced-usage
                  /* meeting.updateUIConfig({'controlBar': false}); */
                }

                //Event callbacks, refer: https://docs.dyte.io/flutter/events/
                meeting.events.on('meetingConnected', this, (ev, cont) {
                  print("Meeting Connected");
                });

                meeting.events.on('meetingJoin', this, (ev, cont) {
                    print("Meeting Join");
                });

                meeting.events.on('meetingDisconnected', this, (ev, cont) {
                  print("Meeting Disconnected");
                });

                meeting.events.on('meetingEnd', this, (ev, cont) {
                  Navigator.of(context).pop();
                  print("Meeting ended");
                });

                meeting.events.on('participantJoin', this, (ev, cont) {
                  DyteParticipant p = ev.eventData as DyteParticipant;
                  print("Participant ${p.name} joined");
                });
                meeting.events.on('participantLeave', this, (ev, cont) {
                  DyteParticipant p = ev.eventData as DyteParticipant;
                  print("Participant ${p.name} left");
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
