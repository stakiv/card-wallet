import 'package:flutter/material.dart';

class MyAddCardPage extends StatefulWidget {
  const MyAddCardPage({super.key});

  @override
  State<MyAddCardPage> createState() => _MyAddCardPageState();
}

class _MyAddCardPageState extends State<MyAddCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Добавление карты')));
  }
}
