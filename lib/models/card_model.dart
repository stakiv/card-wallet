class CardInfo {
  final String shopName;
  final String? shopEngName;
  final String shopImgUrl;
  final String cardNumber;
  final String cardNote;

  CardInfo({
    required this.shopName,
    required this.shopEngName,
    required this.shopImgUrl,
    required this.cardNumber,
    required this.cardNote,
  });

  Map<String, dynamic> toMap() => {
    'shopName': shopName,
    'shopEngName': shopEngName,
    'shopImgUrl': shopImgUrl,
    'cardNumber': cardNumber,
    'cardNote': cardNote,
  };

  factory CardInfo.fromMap(Map<String, dynamic> map) => CardInfo(
    shopName: map['shopName'],
    shopEngName: map['shopEngName'],
    shopImgUrl: map['shopImgUrl'],
    cardNumber: map['cardNumber'],
    cardNote: map['cardNote'],
  );

  CardInfo copyWith({
    String? shopName,
    String? shopEngName,
    String? shopImgUrl,
    String? cardNumber,
    String? cardNote,
  }) {
    return CardInfo(
      shopName: shopName ?? this.shopName,
      shopEngName: shopName ?? this.shopEngName,
      shopImgUrl: shopImgUrl ?? this.shopImgUrl,
      cardNumber: cardNumber ?? this.cardNumber,
      cardNote: cardNote ?? this.cardNote,
    );
  }
}
