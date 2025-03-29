import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hikari/models/category.dart';
import 'package:hikari/category_list.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    List<Category> incomeCategories =
        categories.where((c) => c.isIncome).toList();
    List<Category> expensesCategories =
        categories.where((c) => !c.isIncome).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Alice', style: TextStyle(fontSize: 30)),
        leading: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Icon(FontAwesomeIcons.coins, size: 27),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            iconSize: 35,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Управление категориями',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 20),
            _buildCategorySection(
              'Источники дохода',
              incomeCategories,
              Color(0xFFC4FFAB),
            ),
            const SizedBox(height: 20),
            //const SizedBox(height: 20),
            _buildCategorySection(
              'Расходы',
              expensesCategories,
              Color(0xFFFFD5F0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    List<Category> categories,
    Color? color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Добавить',
                style: TextStyle(
                  color: Color.fromARGB(255, 104, 177, 226),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: categories.length * 70.0,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Text(category.name, style: const TextStyle(fontSize: 18)),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
