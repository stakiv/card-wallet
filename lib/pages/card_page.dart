import 'package:flutter/material.dart';
import 'package:wallet/models/card_model.dart';

class MyCardPage extends StatefulWidget {
  final CardInfo cardInfo;
  const MyCardPage({super.key, required this.cardInfo});
  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.cardInfo.shopName)));
  }
}
