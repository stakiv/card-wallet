import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallet/models/card_model.dart';

class CardProvider extends ChangeNotifier {
  List<CardInfo> _cards = [];
  List<CardInfo> get cards => _cards;
  final Box _box = Hive.box('cardsBox');
  CardProvider() {
    loadCards();
  }

  void loadCards() {
    final cardsFromBox =
        _box.values
            .map((el) => CardInfo.fromMap(Map<String, dynamic>.from(el)))
            .toList();
    _cards = cardsFromBox;
    notifyListeners();
  }

  Future<void> addCard(CardInfo card) async {
    await _box.put(card.cardNumber, card.toMap());
    loadCards();
  }

  Future<void> deleteCard(CardInfo card) async {
    await _box.delete(card.cardNumber);
    loadCards();
  }
}
