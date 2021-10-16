class Watch {
  final String title, price, imageUrl;
  final bool canBuy;

  Watch({
    required this.title,
    required this.price,
    required this.imageUrl,
    this.canBuy = false,
  });

  @override
  String toString() {
    return '${canBuy ? '🔥' : '🥺'} $price - $title';
  }

  String toMessage() {
    return '${canBuy ? '🔥' : '🥺'} $title\n$price\n$imageUrl';
  }
}
