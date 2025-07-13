import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wallet/models/card_model.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:provider/provider.dart';
import 'package:wallet/models/card_provider.dart';

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
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        title: Text(widget.cardInfo.shopName),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String value) async {
              if (value == 'edit') {
                print('Редактировать');
              } else if (value == 'delete') {
                print('Удалить');
                final cardsProvider = Provider.of<CardProvider>(
                  context,
                  listen: false,
                );
                //final box = Hive.box('cardsBox');
                //await box.delete(widget.cardInfo.cardNumber);
                await cardsProvider.deleteCard(widget.cardInfo);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Карта удалена')),
                  );
                  Navigator.of(context).pop();
                }
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(children: [Text('Редактировать')]),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(children: [Text('Удалить')]),
                  ),
                ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: BarcodeWidget(
                  data: widget.cardInfo.cardNumber,
                  barcode: Barcode.code128(),
                  width: 300,
                  height: 160,
                  drawText: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
