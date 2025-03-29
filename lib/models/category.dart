import 'package:hikari/utils/uuid_generator.dart';

class Category {
  final String id;
  final String userId;
  final String name;
  final bool isIncome;

  Category({
    String? id,
    required this.userId,
    required this.name,
    required this.isIncome,
  }) : id = id ?? uuid.v4();
}
