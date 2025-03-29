import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hikari/category_list.dart';
import 'package:hikari/models/category.dart';
import 'package:hikari/models/transaction.dart';
import 'package:hikari/transaction_list.dart';
import 'package:hikari/user_list.dart';

class TransactionWidget extends StatefulWidget {
  const TransactionWidget({super.key});
  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  void deleteTransaction(String transactionId) {
    setState(() {
      transactions.removeWhere(
        (transaction) => transaction.id == transactionId,
      );
    });
  }

  void editTransaction(BuildContext context, Transaction transaction) {
    TextEditingController amountController = TextEditingController(
      text: transaction.amount.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Редактировать транзакцию'),
              content: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Сумма'),
                onChanged: (value) {
                  setStateDialog(() {});
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Отмена'),
                ),
                TextButton(
                  onPressed: () {
                    double? newAmount = double.tryParse(amountController.text);
                    if (newAmount != null) {
                      setState(() {
                        transaction.amount = newAmount;
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showAddTransactionDialog(BuildContext context, bool isIncome) {
    TextEditingController amountController = TextEditingController();
    Category? selectedCategory;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Локальный setState для диалога
            return AlertDialog(
              title: Text(isIncome ? 'Добавить доход' : 'Добавить расход'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Сумма'),
                  ),
                  DropdownButton<Category>(
                    value: selectedCategory,
                    hint: Text('Выберите категорию'),
                    isExpanded: true,
                    items:
                        categories.where((c) => c.isIncome == isIncome).map((
                          category,
                        ) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        // Обновляем UI внутри диалога
                        selectedCategory = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Отмена'),
                ),
                TextButton(
                  onPressed: () {
                    if (amountController.text.isNotEmpty &&
                        selectedCategory != null) {
                      double amount =
                          double.tryParse(amountController.text) ?? 0;
                      if (amount > 0) {
                        setState(() {
                          // Обновляем основной экран
                          transactions.add(
                            Transaction(
                              id: DateTime.now().toString(),
                              userId: users[0].id,
                              amount: isIncome ? amount : -amount,
                              categoryId: selectedCategory!.id,
                              date: DateTime.now(),
                            ),
                          );
                        });
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text('Добавить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
              return ListTile(
                leading: Container(
                  width: 101,
                  height: 46,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        category.isIncome
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
                title: Text(category.name, style: TextStyle(fontSize: 20)),
                subtitle: Text(
                  '${transaction.date.day}.${transaction.date.month}.${transaction.date.year}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => editTransaction(context, transaction),
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => deleteTransaction(transaction.id),
                      icon: Icon(Icons.delete),
                    ),
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
            onTap: () => showAddTransactionDialog(context, false),
          ),
          SpeedDialChild(
            label: 'Добавить доход',
            labelStyle: TextStyle(fontSize: 17),
            labelBackgroundColor: Color(0xFFC4FFAB),
            onTap: () => showAddTransactionDialog(context, true),
          ),
        ],
      ),
    );
  }
}
