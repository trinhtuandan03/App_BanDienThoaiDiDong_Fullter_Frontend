class Orderdetail {
  final int? id;
  final int orderId;
  final int productId;
  final int quantity;
  final double Price;

  Orderdetail({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.Price,
  });

  factory Orderdetail.fromJson(Map<String, dynamic> json) {
    return Orderdetail(
      id: json['id'] ?? 0,
      orderId: json['orderId'] ?? 0,
      productId: json['productId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      Price: (json['productPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id ?? 0,
    "orderId": orderId,
    "productId": productId,
    "quantity": quantity,
    "unitPrice": Price,
  };
}
