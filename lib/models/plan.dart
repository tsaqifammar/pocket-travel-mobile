// To parse this JSON data, do
//
//     final plan = planFromJson(jsonString);

import 'dart:convert';
import 'package:pocket_travel_mobile/models/Schedule.dart';

List<Plan> planFromJson(String str) =>
    List<Plan>.from(json.decode(str).map((x) => Plan.fromJson(x)));

String planToJson(List<Plan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Plan {
  Plan({
    required this.planId,
    required this.name,
    required this.date,
    required this.country,
    required this.schedule,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
  });

  String planId;
  String name;
  DateTime date;
  String country;
  List<Schedule> schedule;
  String userId;
  DateTime updatedAt;
  DateTime createdAt;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        planId: json["plan_id"],
        name: json["name"],
        date: DateTime.parse(json["date"]),
        country: json["country"],
        schedule: List<Schedule>.from(json["schedule"].map((x) => Schedule.fromJson(x))),
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "plan_id": planId,
        "name": name,
        "date": date.toIso8601String(),
        "country": country,
        "schedule": List<dynamic>.from(schedule.map((x) => x.toJson())),
        "user_id": userId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}
