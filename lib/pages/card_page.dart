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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Icon(Icons.edit), Text('Изменить')],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Icon(Icons.delete_outline), Text('Удалить')],
                    ),
                  ),
                ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 15.0),
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
              SizedBox(height: 60.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Дополнительная информация",
                    style: TextStyle(
                      color: Color.fromRGBO(118, 118, 118, 1),
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color.fromRGBO(118, 118, 118, 1),
                    width: 2.0,
                  ),
                ),
                child: Text(
                  widget.cardInfo.cardNote.isNotEmpty
                      ? widget.cardInfo.cardNote
                      : "Нет дополнительной информации",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
