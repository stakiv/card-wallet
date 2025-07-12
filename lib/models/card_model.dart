class CardInfo {
  final String shopName;
  final String shopImgUrl;
  final String cardNumber;

  CardInfo({
    required this.shopName,
    required this.shopImgUrl,
    required this.cardNumber,
  });

  Map<String, dynamic> toMap() => {
    'shopName': shopName,
    'shopImgUrl': shopImgUrl,
    'cardNumber': cardNumber,
  };

  factory CardInfo.fromMap(Map<String, dynamic> map) => CardInfo(
    shopName: map['shopName'],
    shopImgUrl: map['shopImgUrl'],
    cardNumber: map['cardNumber'],
  );
}
