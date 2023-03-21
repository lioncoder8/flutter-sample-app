import 'package:dyte_flutter_sample_app/models/dyte_api.dart';
import 'package:dyte_flutter_sample_app/models/models.dart';
import 'package:dyte_flutter_sample_app/ui_utils/text_field.dart';
import 'package:dyte_flutter_sample_app/utils/constants.dart';
import 'package:dyte_flutter_sample_app/utils/exceptions.dart';
import 'package:flutter/material.dart';

import './dyte_meeting_page.dart';

class JoinMeeting extends StatefulWidget {
  const JoinMeeting({Key? key, required this.mode}) : super(key: key);

  final Mode mode;

  @override
  _JoinMeetingState createState() => _JoinMeetingState();
}

//This houses code for join meeting, when you click on a meeting, it asks for a name and makes a call to backend with participant create request, we recieve an authToken from that and we already have roomName which is passed to the sdk to start the meeting
class _JoinMeetingState extends State<JoinMeeting> {
  int meetingCount = 0;
  List<Meeting> meetings = [];
  List<Meeting> filteredMeetings = [];

  bool isLoading = true;
  bool isErroredState = false;
  bool isSearching = false;

  String participantName = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  void _initializePage() async {
    setState(() {
      isLoading = true;
    });
    try {
      meetings = await DyteAPI.getMeetings();
      meetingCount = meetings.length;
      setState(() {
        isLoading = false;
      });
    } on APIFailureException {
      setState(() {
        isLoading = false;
        isErroredState = true;
      });
    }
  }

  void _handleSearchChange() {
    var searchTerm = _searchController.text.trim();
    if (searchTerm == "") {
      setState(() {
        isSearching = false;
      });
    } else {
      setState(() {
        isSearching = true;
        filteredMeetings = [];
      });
      for (var i = 0; i < meetings.length; i++) {
        var meeting = meetings[i];
        if (meeting.title!.toLowerCase().contains(searchTerm.toLowerCase())) {
          filteredMeetings.add(meeting);
        }
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _initializePage();
    _nameController.addListener(() {
      participantName = _nameController.text.trim();
    });
    _searchController.addListener(_handleSearchChange);
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
                            /* child: const Text('Host'), */
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.blue,
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                ),
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
    return !isLoading
        ? !isErroredState
            ? Column(
                children: <Widget>[
                  TextArea(
                      controller: _searchController, description: 'Search'),
                  Expanded(
                    child: meetingCount > 0
                        ? isSearching
                            ? ListView.builder(
                                itemCount: filteredMeetings.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await _showMeetingDialog(
                                        filteredMeetings[index],
                                      );
                                    },
                                    child: ListTile(
                                      title: Text(
                                          "${filteredMeetings[index].title}",
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: meetingCount,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await _showMeetingDialog(
                                        meetings[index],
                                      );
                                    },
                                    child: ListTile(
                                      title: Text("${meetings[index].title}",
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ),
                                  );
                                },
                              )
                        : const Text('No meetings created'),
                  )
                ],
              )
            : const Text(
                "An error occurred please try again",
                style: TextStyle(color: Colors.white),
              )
        : const CircularProgressIndicator();
  }
}
