import 'package:hikari/utils/uuid_generator.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String password;

  User({
    String? id,
    required this.name,
    required this.email,
    required this.password,
  }) : id = id ?? uuid.v4();
}
