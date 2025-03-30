import 'package:hive/hive.dart';
import 'package:hikari/utils/uuid_generator.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  User({
    String? id,
    required this.name,
    required this.email,
    required this.password,
  }) : id = id ?? uuid.v4();
}
