import 'dart:convert';

class Student {
  final int? id;
  final String name;
  final String last_recorded;

  Student({this.id, required this.name, required this.last_recorded});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'last_recorded': last_recorded,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      last_recorded: map['last_recorded'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) => Student.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Student{id: $id, name: $name, last_recorded: $last_recorded}';
  }
}