import 'package:mobile/modules/common/data/enum/user_type.dart';

/// Represents a user in the system.
/// 
/// This class is used to store and manage user information such as ID,
/// email, name, password, and user type. It also provides methods for JSON
/// serialization and deserialization.
class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserType type;
  final String? deviceToken;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.type,
    this.deviceToken
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      type: UserType.fromString(json['type'] ?? ''),
      deviceToken: json['deviceToken']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'type': type.toJson(),
      'deviceToken': deviceToken
    };
  }
}