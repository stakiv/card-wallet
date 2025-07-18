import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wallet/models/card_model.dart';
import 'package:barcode_widget/barcode_widget.dart' as barcode_widget;
import 'package:provider/provider.dart';
import 'package:wallet/models/card_provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as barcode_scanner;

class MyCardPage extends StatefulWidget {
  final CardInfo cardInfo;
  const MyCardPage({super.key, required this.cardInfo});
  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  bool isEditing = false;
  bool isScanning = false;
  late TextEditingController cardNumberController;
  late TextEditingController cardNoteController;
  late CardInfo _currCardInfo;

  @override
  void initState() {
    super.initState();
    _currCardInfo = widget.cardInfo;
    cardNumberController = TextEditingController(
      text: _currCardInfo.cardNumber,
    );
    cardNoteController = TextEditingController(text: _currCardInfo.cardNote);
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    cardNoteController.dispose();
    super.dispose();
  }

  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  Future<void> saveChanges() async {
    final newCardNumber = cardNumberController.text.trim();
    final newCardNote = cardNoteController.text.trim();

    if (newCardNumber.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Введите номер карты')));
      return;
    }

    final updatedCard = _currCardInfo.copyWith(
      cardNumber: newCardNumber,
      cardNote: newCardNote,
    );
    final cardsProvider = Provider.of<CardProvider>(context, listen: false);
    await cardsProvider.editCard(_currCardInfo, updatedCard);

    setState(() {
      isEditing = false;
      _currCardInfo = updatedCard;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Изменения сохранены')));
  }

  void startScan() {
    setState(() {
      isScanning = true;
    });
  }

  void stopScan() {
    setState(() {
      isScanning = false;
    });
  }

  void onBarCodeDetected(barcode_scanner.BarcodeCapture capture) {
    final List<barcode_scanner.Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? rawValue = barcodes.first.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        cardNumberController.text = rawValue;
        stopScan();
      }
    }
  }

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
                startEditing();
              } else if (value == 'delete') {
                print('Удалить');
                final cardsProvider = Provider.of<CardProvider>(
                  context,
                  listen: false,
                );
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
      body:
          isScanning
              ? barcode_scanner.MobileScanner(onDetect: onBarCodeDetected)
              : Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 15.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isEditing
                          ? Column(
                            children: [
                              ElevatedButton.icon(
                                label: Text(
                                  'сканировать карту',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: startScan,
                                icon: Icon(Icons.qr_code_scanner),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(
                                    255,
                                    218,
                                    218,
                                    1,
                                  ),
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25.0,
                                    vertical: 10.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              TextField(
                                controller: cardNumberController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'номер карты',
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(118, 118, 118, 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 12.0,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 15.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: barcode_widget.BarcodeWidget(
                              data:
                                  isEditing
                                      ? cardNumberController.text
                                      : _currCardInfo.cardNumber,
                              barcode: barcode_widget.Barcode.code128(),
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
                      isEditing
                          ? Column(
                            children: [
                              TextField(
                                controller: cardNoteController,
                                keyboardType: TextInputType.multiline,
                                minLines: 2,
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 12.0,
                                  ),
                                  hintText: 'Дополнительная информация',
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(118, 118, 118, 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(118, 118, 118, 1),
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 150),
                              ElevatedButton.icon(
                                label: Text(
                                  'Сохранить',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () async {
                                  await saveChanges();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(
                                    255,
                                    218,
                                    218,
                                    1,
                                  ),
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 15.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          )
                          : Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color.fromRGBO(118, 118, 118, 1),
                                width: 2.0,
                              ),
                            ),
                            child: Text(
                              _currCardInfo.cardNote.isNotEmpty
                                  ? _currCardInfo.cardNote
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
