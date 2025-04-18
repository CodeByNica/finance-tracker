import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hikari/models/category.dart';
import 'package:hikari/models/transaction.dart';
import 'package:hikari/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeWidget extends StatefulWidget {
  final String currentUserId;

  const HomeWidget({super.key, required this.currentUserId});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Box<User> usersBox;
  late Box<Transaction> transactionsBox;
  late Box<Category> categoriesBox;
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    usersBox = Hive.box<User>('users');
    transactionsBox = Hive.box<Transaction>('transactions');
    categoriesBox = Hive.box<Category>('categories');

    final user = usersBox.get(widget.currentUserId);
    if (user != null) {
      setState(() {
        userName = user.name;
      });
    }
  }

  List<Transaction> get transactions =>
      transactionsBox.values
          .where((t) => t.userId == widget.currentUserId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<Category> get categories =>
      categoriesBox.values
          .where((c) => c.userId == widget.currentUserId)
          .toList();

  double get balance => transactions.fold(0, (sum, item) => sum + item.amount);

  double getIncome() {
    return transactions
        .where((t) => t.amount > 0 && isCurrentMonth(t.date))
        .fold(0, (sum, t) => sum + t.amount);
  }

  double getExpense() {
    return transactions
        .where((t) => t.amount < 0 && isCurrentMonth(t.date))
        .fold(0, (sum, t) => sum + t.amount.abs());
  }

  bool isCurrentMonth(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, $userName', style: TextStyle(fontSize: 30)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: Icon(FontAwesomeIcons.coins, size: 27),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: transactionsBox.listenable(),
        builder: (context, Box<Transaction> box, _) {
          return Center(
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  width: 380,
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Баланс',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      Text(
                        balance.toStringAsFixed(0),
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildInfoBox(
                      'Доходы',
                      getIncome().toStringAsFixed(0),
                      Color(0xFFC4FFAB),
                    ),
                    SizedBox(width: 25),
                    buildInfoBox(
                      'Расходы',
                      getExpense().toStringAsFixed(0),
                      Color(0xFFFFD5F0),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                const Text('Транзакции', style: TextStyle(fontSize: 27)),
                SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    itemCount:
                        transactions.length > 6 ? 6 : transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final category = categories.firstWhere(
                        (c) => c.id == transaction.categoryId,
                        orElse:
                            () => Category(
                              id: '',
                              userId: '',
                              name: 'Неизвестно',
                              isIncome: false,
                            ),
                      );
                      return buildTransactionRow(transaction, category);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildInfoBox(String title, String amount, Color color) {
    return Container(
      width: 175,
      height: 120,
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: color,
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 25)),
          SizedBox(height: 10),
          Text(amount, style: TextStyle(fontSize: 30)),
        ],
      ),
    );
  }

  Widget buildTransactionRow(Transaction transaction, Category category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 101,
            height: 46,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: category.isIncome ? Color(0xFFC4FFAB) : Color(0xFFFFD5F0),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${transaction.amount > 0 ? "+" : ""}${transaction.amount.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(category.name, style: TextStyle(fontSize: 20)),
              Text(
                '${transaction.date.day}.${transaction.date.month}.${transaction.date.year}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
