import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hikari/models/category.dart';
import 'package:hikari/pages/start_page.dart';
import 'package:hive/hive.dart';

class SettingsWidget extends StatefulWidget {
  final String currentUserId;
  const SettingsWidget({super.key, required this.currentUserId});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late Box<Category> categoryBox;
  @override
  void initState() {
    super.initState();
    categoryBox = Hive.box<Category>('categories');
  }

  void deleteCategory(String id) {
    setState(() {
      categoryBox.delete(id);
    });
  }

  void addCategory(bool isIncome) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isIncome ? 'Добавить доход' : 'Добавить расход'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Название категории'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                String name = controller.text.trim();
                if (name.isNotEmpty) {
                  final newCategory = Category(
                    isIncome: isIncome,
                    name: name,
                    userId: widget.currentUserId,
                  );
                  setState(() {
                    categoryBox.put(newCategory.id, newCategory);
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Category> userCategories =
        categoryBox.values
            .where((c) => c.userId == widget.currentUserId)
            .toList();
    List<Category> incomeCategories =
        userCategories.where((c) => c.isIncome).toList();
    List<Category> expensesCategories =
        userCategories.where((c) => !c.isIncome).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки', style: TextStyle(fontSize: 30)),
        leading: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Icon(FontAwesomeIcons.coins, size: 27),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final settingsBox = Hive.box('settings');
              await settingsBox.delete('currentUserId');
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartPage()),
                  (route) => false,
                );
              }
            },
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
              () => addCategory(true),
            ),
            const SizedBox(height: 20),
            _buildCategorySection(
              'Расходы',
              expensesCategories,
              Color(0xFFFFD5F0),
              () => addCategory(false),
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
    VoidCallback onAddCategory,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            TextButton(
              onPressed: onAddCategory,
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
                      onPressed: () => deleteCategory(category.id),
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
