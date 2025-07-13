import 'package:flutter/material.dart';
import 'package:wallet/components/card_item.dart';
import 'package:wallet/pages/add_card_page.dart';
import 'package:hive/hive.dart';
import 'package:wallet/models/card_model.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  List<CardInfo> localCards = [];

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  void loadCards() {
    final box = Hive.box('cardsBox');
    final cards =
        box.values
            .map((el) => CardInfo.fromMap(Map<String, dynamic>.from(el)))
            .toList();
    setState(() {
      localCards = cards;
    });
  }

  Future<void> _navigateToAddCard() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyAddCardPage()),
    );
    loadCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        title: const Text('Мои карты'),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            localCards.isEmpty
                ? Center(
                  child: Text(
                    'У вас пока нет сохраненных карт',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 18.0,
                    ),
                  ),
                )
                : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: localCards.length,
                  itemBuilder: (BuildContext context, int index) {
                    final card = localCards[index];
                    return CardItem(card: card);
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCard,
        backgroundColor: Color.fromRGBO(255, 218, 218, 1),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
