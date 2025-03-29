import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hikari/category_list.dart';
import 'package:hikari/models/category.dart';
import 'package:hikari/transaction_list.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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
        title: Text('Hello Alice', style: TextStyle(fontSize: 30)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: Icon(FontAwesomeIcons.coins, size: 27),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 15),
            Container(
              width: 380,
              height: 80,
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  const Text(
                    'Баланс',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const SizedBox(width: 150),
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
                Container(
                  width: 175,
                  height: 120,
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0xFFC4FFAB),
                  ),
                  child: Column(
                    children: [
                      const Text('Доходы', style: TextStyle(fontSize: 25)),
                      SizedBox(height: 10),
                      Text(
                        getIncome().toStringAsFixed(0),
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25),
                Container(
                  width: 175,
                  height: 120,
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0xFFFFD5F0),
                  ),
                  child: Column(
                    children: [
                      const Text('Расходы', style: TextStyle(fontSize: 25)),
                      SizedBox(height: 10),
                      Text(
                        getExpense().toStringAsFixed(0),
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            const Text('Транзакции', style: TextStyle(fontSize: 27)),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: transactions.length > 6 ? 6 : transactions.length,
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
                          color:
                              category.isIncome
                                  ? Color(0xFFC4FFAB)
                                  : Color(0xFFFFD5F0),
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
