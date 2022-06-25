import 'dart:convert';

List<Checklist> checklistFromJson(String str) =>
    List<Checklist>.from(json.decode(str).map((x) => Checklist.fromJson(x)));

String checklistToJson(List<Checklist> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Checklist {
  Checklist({
    required this.item_id,
    required this.name,
    required this.is_checked,
  });

  String item_id;
  String name;
  bool is_checked;

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      item_id: json['item_id'] as String,
      name: json['name'] as String,
      is_checked: json['is_checked'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        "item_id": item_id,
        "name": name,
        "is_checked": is_checked,
      };
}
