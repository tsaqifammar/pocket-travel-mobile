import 'dart:ffi';

class Checklist {
  final String name;
  final Bool is_checked;

  Checklist({required this.name, required this.is_checked});

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      name: json['name'] as String,
      is_checked: json['is_checked'] as Bool,
    );
  }

  @override
  String toString() {
    return 'Checklist{name: $name, is_checked: $is_checked}';
  }
}
