import 'package:hive/hive.dart';
import 'package:hikari/utils/uuid_generator.dart';

part 'transaction.g.dart';

@HiveType(typeId: 2)
class Transaction {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String categoryId;

  @HiveField(4)
  DateTime date;

  Transaction({
    String? id,
    required this.userId,
    required this.amount,
    required this.categoryId,
    required this.date,
  }) : id = id ?? uuid.v4();
}
