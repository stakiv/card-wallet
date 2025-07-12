import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallet/pages/card_page.dart';
import 'package:wallet/models/card_model.dart';

class CardItem extends StatelessWidget {
  final CardInfo card;
  const CardItem({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCardPage(cardInfo: card)),
          ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: card.shopImgUrl,
                placeholder:
                    (context, url) => const CircularProgressIndicator(),
                errorWidget:
                    (context, url, error) => const Icon(
                      Icons.error,
                      color: Color.fromRGBO(162, 193, 199, 0.612),
                    ),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
