import 'package:flutter/material.dart';
import 'package:wallet/models/card_model.dart';
import 'package:barcode_widget/barcode_widget.dart';

class MyCardPage extends StatefulWidget {
  final CardInfo cardInfo;
  const MyCardPage({super.key, required this.cardInfo});
  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cardInfo.shopName)),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
        child: Column(
          children: [
            BarcodeWidget(
              data: widget.cardInfo.cardNumber,
              barcode: Barcode.code128(),
              width: 300,
              height: 80,
              drawText: true,
            ),
          ],
        ),
      ),
    );
  }
}
