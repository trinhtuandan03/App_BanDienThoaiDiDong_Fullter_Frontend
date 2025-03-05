class Order {
  Order({
    this.id,
    required this.userId,
    required this.orderDate,
    required this.orderStatus,
    required this.totalPrice,
    required this.paymentMethod,
    required this.shippingAddress,
  });

  final int? id;
  final String userId;
  final DateTime orderDate;
  final String orderStatus;
  final double totalPrice;
  final String paymentMethod;
  final String shippingAddress;

  Map<String, dynamic> toJson() {
    // Truyền giá trị id là 0 nếu không có để tránh lỗi conversion
    return {
      "id": id ?? 0,  // Đảm bảo kiểu int
      "userId": userId,
      "orderDate": orderDate.toIso8601String(),
      "orderStatus": orderStatus,
      "totalPrice": totalPrice,
      "paymentMethod": paymentMethod,
      "shippingAddress": shippingAddress
    };
  }
}
