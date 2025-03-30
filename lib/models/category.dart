import 'package:hive/hive.dart';
import 'package:hikari/utils/uuid_generator.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final bool isIncome;

  Category({
    String? id,
    required this.userId,
    required this.name,
    required this.isIncome,
  }) : id = id ?? uuid.v4();
}
