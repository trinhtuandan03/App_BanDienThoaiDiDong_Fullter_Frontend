class Cartdetail {
  Cartdetail({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  final int? id;
  final int? cartId;
  final int? productId;
  final int? quantity;

  factory Cartdetail.fromJson(Map<String, dynamic> json){
    return Cartdetail(
      id: json["id"],
      cartId: json["cartId"],
      productId: json["productId"],
      quantity: json["quantity"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "cartId": cartId,
    "productId": productId,
    "quantity": quantity,
  };

}
