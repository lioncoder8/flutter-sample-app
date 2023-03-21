import 'package:dyte_flutter_sample_app/models/dyte_api.dart';
import 'package:dyte_flutter_sample_app/models/models.dart';
import 'package:dyte_flutter_sample_app/ui_utils/text_field.dart';
import 'package:dyte_flutter_sample_app/utils/constants.dart';
import 'package:dyte_flutter_sample_app/utils/exceptions.dart';
import 'package:flutter/material.dart';

import './dyte_meeting_page.dart';

class CreateMeeting extends StatefulWidget {
  const CreateMeeting({Key? key, required this.mode}) : super(key: key);

  final Mode mode;

  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

//CreateMeeting houses the code to create a new meeting, here we are using mode in joinRoom part to make a distinction between webinar and normal call.
//This houses the same call as join meeting as firstly meeting is created using DyteAPI's createMeeting call and then we follow the same process as join meeting
class _CreateMeetingState extends State<CreateMeeting> {
  String meetingTitle = "";
  String participantName = "";

  bool isLoading = false;
  bool isErroredState = false;

  final TextEditingController _meetingTitleController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      participantName = _nameController.text.trim();
    });

    _meetingTitleController.addListener(() {
      meetingTitle = _meetingTitleController.text.trim();
    });
  }

  Future<void> _joinRoom(
      Meeting meeting, bool isHost, Function setState) async {
    try {
      setState(() {
        isLoading = true;
      });
      //Note usage of mode here
      var authToken = await DyteAPI.createParticipant(meeting, isHost,
          widget.mode == Mode.webinar ? true : false, participantName);
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DyteMeetingPage(
              roomName: meeting.roomName!,
              authToken: authToken,
              mode: widget.mode,
            )),
      );
    } on APIFailureException {
      setState(() {
        isErroredState = true;
        isLoading = false;
      });
    }
  }

  Future<void> _showMeetingDialog(Meeting meeting) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: Text('Join ${meeting.roomName} as'),
              children: !isErroredState
                  ? !isLoading
                      ? <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter your name',
                              ),
                            ),
                          ),
                          SimpleDialogOption(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.blue,
                              ),
                              onPressed: () {
                                _joinRoom(meeting, true, setState);
                              },
                              child: const Text(
                                'Host',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () {},
                          ),
                          SimpleDialogOption(
                            /* child: const Text('Participant'), */
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.blue,
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                _joinRoom(meeting, false, setState);
                              },
                              child: const Text(
                                'Participant',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ]
                      : <Widget>[
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ]
                  : <Widget>[
                      const Center(
                        child: Text('An error occurred!'),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        "Enter meeting title",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 21,
        ),
      ),
      TextArea(
          controller: _meetingTitleController,
          description: "Enter meeting title"),
      TextButton(
        onPressed: () async {
          try {
            var meeting = await DyteAPI.createMeeting(meetingTitle);
            await _showMeetingDialog(meeting);
          } on APIFailureException {
            setState(() {
              isLoading = false;
              isErroredState = true;
            });
          }
        },
        child: !isLoading
            ? Text(
                isErroredState ? "Retry" : "Create",
                style: const TextStyle(
                  color: Colors.white,
                ),
              )
            : const CircularProgressIndicator(),
      ),
      isErroredState
          ? const Text(
              "Meeting could not be created, try again",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          : Container(),
    ]);
  }
}
