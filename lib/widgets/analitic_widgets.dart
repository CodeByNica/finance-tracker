import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hikari/category_list.dart';
import 'package:hikari/models/category.dart';
import 'package:hikari/models/transaction.dart';
import 'package:hikari/transaction_list.dart';

class AnaliticWidget extends StatefulWidget {
  const AnaliticWidget({super.key});
  @override
  State<AnaliticWidget> createState() => _AnaliticWidgetState();
}

class _AnaliticWidgetState extends State<AnaliticWidget> {
  bool isIncomeChart = false;

  Map<String, double> calculateCategorySums(
    List<Transaction> transactions,
    bool isIncome,
  ) {
    Map<String, double> categorySums = {};
    for (var transaction in transactions) {
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
      if (category.isIncome == isIncome) {
        categorySums.update(
          category.name,
          (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }
    }
    return categorySums;
  }

  Map<int, double> getTransactionsByMonth(
    List<Transaction> transations,
    bool isIncome,
  ) {
    Map<int, double> transactionsByMonth = {};
    for (var transaction in transations) {
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
      if (category.isIncome == isIncome) {
        int month = transaction.date.month;
        transactionsByMonth[month] =
            (transactionsByMonth[month] ?? 0) + transaction.amount;
      }
    }
    return transactionsByMonth;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> expenseCategories = calculateCategorySums(
      transactions,
      false,
    );
    Map<String, double> incomeCategories = calculateCategorySums(
      transactions,
      true,
    );

    List<FlSpot> spots =
        getTransactionsByMonth(transactions, isIncomeChart).entries
            .map(
              (entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()),
            )
            .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Аналитика', style: TextStyle(fontSize: 27)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isIncomeChart = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            isIncomeChart ? Colors.grey[300] : Colors.black,
                        foregroundColor:
                            isIncomeChart ? Colors.black : Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Расходы",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isIncomeChart = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            isIncomeChart ? Colors.black : Colors.grey[300],
                        foregroundColor:
                            isIncomeChart ? Colors.white : Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Доходы", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                const Text(
                  'Расходы по категориям',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 170,
                  height: 170,
                  child: PieChart(
                    PieChartData(
                      sections:
                          expenseCategories.entries.map((entry) {
                            return PieChartSectionData(
                              value: entry.value,
                              title: entry.key,
                              color: Color(0xFFFFD5F0),
                              radius: 50,
                            );
                          }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  "Доходы по категориям",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 170,
                  height: 170,
                  child: PieChart(
                    PieChartData(
                      sections:
                          incomeCategories.entries.map((entry) {
                            return PieChartSectionData(
                              value: entry.value,
                              title: entry.key,
                              color: Color(0xFFC4FFAB),
                              radius: 50,
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
