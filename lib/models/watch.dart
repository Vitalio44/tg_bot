class Watch {
  final String title, price;
  final bool canBuy;

  Watch({required this.title, required this.price, this.canBuy = false});

  @override
  String toString() {
    return '${canBuy ? '🔥' : '🥺'} $price - $title';
  }
}
