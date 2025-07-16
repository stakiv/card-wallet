import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:wallet/models/card_model.dart';
import 'package:wallet/models/card_provider.dart';
import 'package:wallet/pages/main_page.dart';

class MyAddCardInfoPage extends StatefulWidget {
  const MyAddCardInfoPage({
    super.key,
    required this.shopName,
    required this.shopImg,
  });
  final String shopName;
  final String shopImg;

  @override
  State<MyAddCardInfoPage> createState() => _MyAddCardInfoPageState();
}

class _MyAddCardInfoPageState extends State<MyAddCardInfoPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isScanning = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
    });
  }

  void _stopScan() {
    setState(() {
      _isScanning = false;
    });
  }

  void _onBarCodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? rawValue = barcodes.first.rawValue;
      if (rawValue != null && rawValue.isNotEmpty) {
        _cardNumberController.text = rawValue;
        _stopScan();
      }
    }
  }

  /*
  void saveCard(CardInfo card) {
    final box = Hive.box('cardsBox');
    box.put(card.cardNumber, card.toMap());
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        title: Text(widget.shopName),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      ),
      body:
          _isScanning
              ? MobileScanner(onDetect: _onBarCodeDetected)
              : Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 1.3,
                            child: Image.network(
                              widget.shopImg,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      ElevatedButton.icon(
                        label: Text(
                          'сканировать карту',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: _startScan,
                        icon: Icon(Icons.qr_code_scanner),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 218, 218, 1),
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
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'номер карты',
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(118, 118, 118, 1),
                          ),
                          prefixIcon: Icon(Icons.credit_card),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(118, 118, 118, 1),
                              width: 2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        minLines: 2,
                        maxLines: null,
                        controller: _noteController,
                        keyboardType: TextInputType.multiline,
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
                          'Продолжить',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          final cardNumber = _cardNumberController.text.trim();
                          final cardNote = _noteController.text.trim();
                          if (cardNumber.isEmpty || cardNumber == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Введите номер карты')),
                            );
                            return;
                          } else {
                            final card = CardInfo(
                              shopName: widget.shopName,
                              shopImgUrl: widget.shopImg,
                              cardNumber: cardNumber,
                              cardNote: cardNote,
                            );
                            final cardsProvider = Provider.of<CardProvider>(
                              context,
                              listen: false,
                            );

                            //saveCard(card);
                            await cardsProvider.addCard(card);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Карта успешно сохранена'),
                              ),
                            );
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const MyMainPage(),
                              ),
                            );
                          }
                        },
                        //icon: Icon(Icons.qr_code_scanner),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 218, 218, 1),
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
                  ),
                ),
              ),
    );
  }
}
