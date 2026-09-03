/// 待买清单 - 单条物品
class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  final double price; // 预估单价
  final bool bought;
  final String note;

  const ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.price = 0,
    this.bought = false,
    this.note = '',
  });

  double get totalPrice => price * quantity;

  ShoppingItem copyWith({
    String? name,
    int? quantity,
    double? price,
    bool? bought,
    String? note,
  }) =>
      ShoppingItem(
        id: id,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        bought: bought ?? this.bought,
        note: note ?? this.note,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'price': price,
        'bought': bought,
        'note': note,
      };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
        id: json['id'] as String,
        name: json['name'] as String,
        quantity: json['quantity'] as int? ?? 1,
        price: (json['price'] as num?)?.toDouble() ?? 0,
        bought: json['bought'] as bool? ?? false,
        note: json['note'] as String? ?? '',
      );
}
