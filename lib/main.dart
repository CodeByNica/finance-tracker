import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hikari/models/user.dart';
import 'package:hikari/models/category.dart';
import 'package:hikari/models/transaction.dart';
import 'package:hikari/pages/start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); //инициализация hive

  //регистрация адаптеров
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TransactionAdapter());

  //открываю хранилище
  await Hive.openBox<User>('users');
  await Hive.openBox<Category>('categories');
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox('settings');

  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StartPage(), debugShowCheckedModeBanner: false);
  }
}
