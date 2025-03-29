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

  final List<Color> pieColors = [
    Color(0xFFFFD5F0),
    Color(0xFFF9E79F),
    Color(0xFFC4FFAB),
    Color(0xFF85C1E9),
    Color(0xFFA569BD),
    Color(0xFFFFA07A),
  ];

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
          (value) => value + transaction.amount.abs(),
          ifAbsent: () => transaction.amount.abs(),
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
        double amount = transaction.amount.abs();
        transactionsByMonth[month] = (transactionsByMonth[month] ?? 0) + amount;
      }
    }
    return transactionsByMonth;
  }

  @override
  Widget build(BuildContext context) {
    int selectedMonth = DateTime.now().month;

    List<Transaction> filteredTransactions =
        transactions
            .where((transaction) => transaction.date.month == selectedMonth)
            .toList();

    Map<String, double> categoryData = calculateCategorySums(
      filteredTransactions,
      isIncomeChart,
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
                            isIncomeChart
                                ? Colors.grey[200]
                                : Color(0xFFFFD5F0),
                        foregroundColor: Colors.black,
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
                    SizedBox(width: 25),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isIncomeChart = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            isIncomeChart
                                ? Color(0xFFC4FFAB)
                                : Colors.grey[200],
                        foregroundColor: Colors.black,
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
                SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color:
                              isIncomeChart
                                  ? Color.fromARGB(255, 183, 245, 156)
                                  : Color.fromARGB(255, 255, 185, 231),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  isIncomeChart
                      ? 'Доходы по категориям'
                      : 'Расходы по категориям',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 170,
                  height: 170,
                  child: PieChart(
                    PieChartData(
                      sections:
                          categoryData.entries.map((entry) {
                            int index = categoryData.keys.toList().indexOf(
                              entry.key,
                            );
                            return PieChartSectionData(
                              value: entry.value,
                              color: pieColors[index % pieColors.length],
                              radius: 50,
                              showTitle: false,
                            );
                          }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children:
                      categoryData.entries.map((entry) {
                        int index = categoryData.keys.toList().indexOf(
                          entry.key,
                        );
                        return Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: pieColors[index % pieColors.length],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(entry.key, style: TextStyle(fontSize: 16)),
                            Spacer(),
                            Text(
                              '${entry.value.abs().toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
