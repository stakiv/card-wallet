import 'package:flutter/material.dart';

class MyCardPage extends StatefulWidget {
  const MyCardPage({super.key, required this.cardName});
  final String cardName;
  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.cardName)));
  }
}
