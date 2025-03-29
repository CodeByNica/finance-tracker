import 'package:hikari/utils/uuid_generator.dart';

class Transaction {
  final String id;
  final String userId;
  final double amount;
  final String categoryId;
  final DateTime date;

  Transaction({
    String? id,
    required this.userId,
    required this.amount,
    required this.categoryId,
    required this.date,
  }) : id = id ?? uuid.v4();
}
