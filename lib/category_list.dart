import 'package:hikari/models/category.dart';
import 'package:hikari/utils/uuid_generator.dart';
import 'package:hikari/user_list.dart';

final List<Category> categories = [
  Category(
    id: uuid.v4(),
    userId: users[0].id,
    name: 'Зарплата',
    isIncome: true,
  ),
  Category(
    id: uuid.v4(),
    userId: users[0].id,
    name: 'Продукты',
    isIncome: false,
  ),
  Category(
    id: uuid.v4(),
    userId: users[0].id,
    name: 'Транспорт',
    isIncome: false,
  ),
  Category(
    id: uuid.v4(),
    userId: users[0].id,
    name: 'Ресторан',
    isIncome: false,
  ),
];
