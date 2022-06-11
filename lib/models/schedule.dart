// To parse this JSON data, do
//
//     final schedule = scheduleFromJson(jsonString);

import 'dart:convert';

List<Schedule> scheduleFromJson(String str) =>
    List<Schedule>.from(json.decode(str).map((x) => Schedule.fromJson(x)));

String scheduleToJson(List<Schedule> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Schedule {
  Schedule({
    required this.time,
    required this.activity,
  });

  String time;
  String activity;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        time: json["time"],
        activity: json["activity"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "activity": activity,
      };
}
