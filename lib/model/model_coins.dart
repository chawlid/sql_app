class ModelCoins {
  final int id;
  final String img;
  final String? symbol;
  final String? name;
  final int? selected;

  ModelCoins({
    required this.id,
    required this.img,
    this.symbol,
    this.name,
    this.selected,
  });

  factory ModelCoins.fromMap(Map<String, dynamic> map) {
    return ModelCoins(
      id: map['id'],
      img: map['img'],
      symbol: map['symbol'],
      name: map['name'],
      selected: map['selected'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'img': img,
      'symbol': symbol,
      'name': name,
      'selected': selected,
    };
  }
}
