class Cart {
  Cart({
    required this.id,
    required this.userId,
    required this.paymentMethod,
    required this.createdAt,
  });

  final int? id;
  final String? userId;
  final String? paymentMethod;
  final DateTime? createdAt;

  factory Cart.fromJson(Map<String, dynamic> json){
    return Cart(
      id: json["id"],
      userId: json["userId"],
      paymentMethod: json["paymentMethod"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "paymentMethod": paymentMethod,
    "createdAt": createdAt?.toIso8601String(),
  };

}
