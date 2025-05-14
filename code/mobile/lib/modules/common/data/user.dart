import 'package:mobile/modules/common/data/enum/user_type.dart';

/// Represents a user in the system.
/// 
/// This class is used to store and manage user information such as ID,
/// username, name, and user type. It also provides methods for JSON
/// serialization and deserialization.
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