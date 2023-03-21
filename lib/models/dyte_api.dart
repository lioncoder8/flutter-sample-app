import 'dart:convert';
import 'package:dyte_flutter_sample_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:dyte_flutter_sample_app/models/models.dart';
import 'package:dyte_flutter_sample_app/utils/exceptions.dart';

//This is a custom API and may be replaced with anything satifying the needs
class DyteAPI {
  //makes the particpant create request
  static Future<String> createParticipant(
    Meeting meeting,
    bool isHost,
    bool isWebinar,
    String name,
  ) async {
    Map<String, dynamic> body = {
      'meetingId': meeting.id,
      'clientSpecificId': const Uuid().v1(),
      'userDetails': <String, String>{
        "name": name,
      },
    };

    if (isWebinar) {
      body["presetName"] = isHost
          ? "default_webinar_host_preset"
          : "default_webinar_participant_preset";
    } else {
      body["roleName"] = isHost ? "host" : "participant";
    }

    var url = Uri.parse(Constants.baseURL + "/participant/create");
    var response = await http.post(url,
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(body));

    if (response.statusCode != 200) {
      throw APIFailureException();
    }

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    var authToken = decodedResponse["data"]["authResponse"]["authToken"];

    return authToken;
  }

  //makes the meeting create request
  static Future<Meeting> createMeeting(String meetingTitle) async {
    var url = Uri.parse(Constants.baseURL + "/meeting/create");
    var response = await http.post(url,
        headers: <String, String>{
          "Content-Type": "application/json",
        },
        body: jsonEncode(<String, dynamic>{
          'title': meetingTitle,
          'presetName': 'host',
          'authorization': <String, bool>{'waitingRoom': false, 'closed': false}
        }));

    if (response.statusCode != 200) {
      throw APIFailureException();
    }

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    var data = decodedResponse["data"] as Map;
    var meetingJson = data["meeting"] as Map<String, dynamic>;

    var meeting = Meeting.fromJson(meetingJson);

    return meeting;
  }

  //makes the meeting list request
  static Future<List<Meeting>> getMeetings() async {
    var url = Uri.parse(Constants.baseURL + "/meetings/");
    var response = await http.get(url);

    if (response.statusCode != 200) {
        throw APIFailureException();
    }
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    var data = decodedResponse["data"] as Map;
    var meetingsJson = data["meetings"] as List<dynamic>;
    var meetings = MeetingList.fromJsonList(meetingsJson).meetings!;

    return meetings;
  }
}
