import 'package:hikari/models/transaction.dart';
import 'package:hikari/utils/uuid_generator.dart';
import 'package:hikari/category_list.dart';
import 'package:hikari/user_list.dart';

final List<Transaction> transactions = [
  Transaction(
    id: uuid.v4(),
    userId: users[0].id,
    categoryId: categories[0].id, // Зарплата
    amount: 10000,
    date: DateTime.now(),
  ),
  Transaction(
    id: uuid.v4(),
    userId: users[0].id,
    categoryId: categories[1].id, // Продукты
    amount: -1000,
    date: DateTime.now(),
  ),
  Transaction(
    id: uuid.v4(),
    userId: users[1].id,
    categoryId: categories[2].id, // Транспорт
    amount: -3000,
    date: DateTime.now(),
  ),
  Transaction(
    id: uuid.v4(),
    userId: users[1].id,
    categoryId: categories[3].id, // Ресторан
    amount: -6000,
    date: DateTime.utc(2025, 2, 27),
  ),
  Transaction(
    id: uuid.v4(),
    userId: users[0].id,
    categoryId: categories[0].id, // Перевод
    amount: 36000,
    date: DateTime.utc(2025, 2, 15),
  ),
  Transaction(
    id: uuid.v4(),
    userId: users[0].id,
    categoryId: categories[1].id, // Аптека
    amount: -900,
    date: DateTime.utc(2025, 2, 14),
  ),
  Transaction(
    id: uuid.v4(),
    userId: users[1].id,
    categoryId: categories[1].id, // Продукты
    amount: -1500,
    date: DateTime.utc(2025, 2, 11),
  ),
];
