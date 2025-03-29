import 'package:hikari/utils/uuid_generator.dart';

class Transaction {
  final String id;
  final String userId;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String icon;

  Transaction({
    String? id,
    required this.userId,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.icon,
  }) : id = id ?? uuid.v4();
}
