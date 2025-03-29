import 'package:hikari/models/transaction.dart';

final List<Transaction> transactions = [
  Transaction(
    category: 'Зарплата',
    amount: 10000,
    date: DateTime.now(),
    isIncome: true,
  ),
  Transaction(
    category: 'Продукты',
    amount: -1000,
    date: DateTime.now(),
    isIncome: false,
  ),
  Transaction(
    category: 'Транспорт',
    amount: -3000,
    date: DateTime.now(),
    isIncome: false,
  ),
  Transaction(
    category: 'Ресторан',
    amount: -6000,
    date: DateTime.utc(2025, 2, 27),
    isIncome: false,
  ),
  Transaction(
    category: 'Перевод',
    amount: 36000,
    date: DateTime.utc(2025, 2, 15),
    isIncome: true,
  ),
  Transaction(
    category: 'Аптека',
    amount: -900,
    date: DateTime.utc(2025, 2, 14),
    isIncome: false,
  ),
  Transaction(
    category: 'Продукты',
    amount: -1500,
    date: DateTime.utc(2025, 2, 11),
    isIncome: false,
  ),
];
