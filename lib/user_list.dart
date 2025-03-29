import 'package:hikari/models/user.dart';
import 'package:hikari/utils/uuid_generator.dart';

final List<User> users = [
  User(
    id: uuid.v4(),
    name: 'Alice',
    email: 'alice@example.com',
    password: 'password123',
  ),
  User(
    id: uuid.v4(),
    name: 'Bob',
    email: 'bob@example.com',
    password: 'securepass',
  ),
];
