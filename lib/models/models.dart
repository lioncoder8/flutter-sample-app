//Internal representation for a meeting
class Meeting {
  String? id;
  String? title;
  String? roomName;
  String? status;
  String? createdAt;
  List<dynamic>? participants;

  Meeting({
    this.id,
    this.title,
    this.roomName,
    this.status,
    this.createdAt,
    this.participants,
  });

  factory Meeting.fromJson(Map<dynamic, dynamic> json) {
    return Meeting(
      id: json["id"],
      title: json["title"],
      roomName: json["roomName"],
      status: json["status"],
      createdAt: json["createdAt"],
      participants: json["participants"],
    );
  }
}

class MeetingList {
  List<Meeting>? meetings;

  MeetingList({
    this.meetings,
  });

  factory MeetingList.fromJsonList(List<dynamic> jsonList) {
    return MeetingList(
        meetings: jsonList.map((json) => Meeting.fromJson(json)).toList());
  }
}
