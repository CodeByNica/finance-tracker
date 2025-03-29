import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});
  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello Alice', style: TextStyle(fontSize: 30)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: Icon(FontAwesomeIcons.coins, size: 27),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            iconSize: 35,
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
