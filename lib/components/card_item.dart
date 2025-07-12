import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallet/pages/card_page.dart';

class CardItem extends StatelessWidget {
  final String card;
  const CardItem({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCardPage(cardName: card)),
          ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: ClipRRect(
          child: CachedNetworkImage(
            imageUrl: card,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget:
                (context, url, error) => const Icon(
                  Icons.error,
                  color: Color.fromRGBO(162, 193, 199, 0.612),
                ),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
