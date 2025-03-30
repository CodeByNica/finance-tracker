import 'package:flutter/material.dart';
import 'package:hikari/widgets/home_widgets.dart';
import 'package:hikari/widgets/transaction_widgets.dart';
import 'package:hikari/widgets/analitic_widgets.dart';
import 'package:hikari/widgets/settings_widgets.dart';
import 'package:hive/hive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  void loadUserId() {
    final settingsBox = Hive.box('settings');
    setState(() {
      currentUserId = settingsBox.get('currentUserId');
    });
  }

  void onSelectedItem(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  Widget getCurrentPage() {
    switch (currentPageIndex) {
      case 0:
        return HomeWidget(currentUserId: currentUserId!);
      case 1:
        return TransactionWidget(currentUserId: currentUserId!);
      case 2:
        return AnaliticWidget(currentUserId: currentUserId!);
      case 3:
        return SettingsWidget(currentUserId: currentUserId!);
      default:
        return const Center(child: Text('Page???'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getCurrentPage(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: onSelectedItem,
        selectedIndex: currentPageIndex,
        indicatorColor: Color(0xFFFFD5F0),
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            label: 'Transaction',
            selectedIcon: Icon(Icons.savings),
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            label: 'Analitics',
            selectedIcon: Icon(Icons.analytics),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
            selectedIcon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
