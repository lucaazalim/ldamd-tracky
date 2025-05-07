import 'package:mobile/modules/common/data/enum/user_type.dart';

class User {
  final int id;
  final String username;
  final String name;
  final UserType type;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      type: UserType.fromString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'type': type.toJson(),
    };
  }
}