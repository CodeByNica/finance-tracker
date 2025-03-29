import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hikari/transaction_list.dart';

class TransactionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Транзакции', style: TextStyle(fontSize: 28)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                leading: Container(
                  width: 101,
                  height: 46,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        transaction.isIncome
                            ? Color(0xFFC4FFAB)
                            : Color(0xFFFFD5F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${transaction.amount > 0 ? "+" : ""}${transaction.amount.toStringAsFixed(0)}',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
                title: Text(
                  transaction.category,
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  '${transaction.date.day}.${transaction.date.month}.${transaction.date.year}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            label: 'Добавить расход',
            labelStyle: TextStyle(fontSize: 17),
            labelBackgroundColor: Color(0xFFFFD5F0),
            onTap: () {},
          ),
          SpeedDialChild(
            label: 'Добавить доход',
            labelStyle: TextStyle(fontSize: 17),
            labelBackgroundColor: Color(0xFFC4FFAB),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
