import 'package:flutter/material.dart';
import 'package:trinhtuandan_nhom3_2180602115/models/product.dart';
import 'package:trinhtuandan_nhom3_2180602115/models/order.dart';
import 'package:trinhtuandan_nhom3_2180602115/models/orderdetail.dart';
import 'package:trinhtuandan_nhom3_2180602115/services/auth_service.dart';
import 'package:trinhtuandan_nhom3_2180602115/services/order_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen extends StatefulWidget {
  final Product product;
  final int quantity;
  final double totalPrice;

  const OrderScreen({
    super.key,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _paymentMethodController =
      TextEditingController();
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();
  late int _quantity;
  String? _userId;
  String _selectedLanguage = 'Tiếng Việt';

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
    _loadUserId();
    _loadLanguage();
  }

  Future<void> _loadUserId() async {
    String? userId = await _authService.getUserId();
    setState(() {
      _userId = userId ?? 'Unknown';
    });
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'Tiếng Việt';
    });
  }

  void _incrementQuantity() => setState(() => _quantity++);

  void _decrementQuantity() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  Future<void> _saveNotification(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];
    notifications.add(message);
    await prefs.setStringList('notifications', notifications);
  }

  Future<void> placeOrder() async {
    try {
      if (_addressController.text.isEmpty ||
          _paymentMethodController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_selectedLanguage == 'Tiếng Việt'
                  ? 'Vui lòng nhập đầy đủ thông tin đơn hàng'
                  : 'Please fill in all order details')),
        );
        return;
      }

      final order = Order(
        id: null,
        userId: _userId!,
        orderDate: DateTime.now(),
        orderStatus: 'Pending',
        totalPrice: widget.totalPrice * _quantity,
        paymentMethod: _paymentMethodController.text,
        shippingAddress: _addressController.text,
      );

      final int? orderId = await _orderService.createOrder(order);
      if (orderId != null) {
        final orderDetail = Orderdetail(
          orderId: orderId,
          productId: widget.product.id!,
          quantity: _quantity,
          Price: order.totalPrice,
        );

        bool detailSuccess = await _orderService.createOrderDetail(orderDetail);

        if (detailSuccess) {
          await _saveNotification(_selectedLanguage == 'Tiếng Việt'
              ? 'Đặt hàng thành công!'
              : 'Order placed successfully!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(_selectedLanguage == 'Tiếng Việt'
                    ? 'Đặt hàng và chi tiết đơn hàng thành công!'
                    : 'Order and order details created successfully!')),
          );
          Navigator.pop(context);
        } else {
          throw Exception('Không thể tạo chi tiết đơn hàng');
        }
      } else {
        throw Exception('Không thể tạo đơn hàng');
      }
    } catch (e) {
      await _saveNotification(_selectedLanguage == 'Tiếng Việt'
          ? 'Lỗi khi đặt hàng'
          : 'Error placing order');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                _selectedLanguage == 'Tiếng Việt' ? 'Lỗi: $e' : 'Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';
    return Scaffold(
      appBar: AppBar(
        title: Text(isVietnamese ? 'Xác nhận Đơn hàng' : 'Confirm Order'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  widget.product.image1 ?? 'https://via.placeholder.com/150'),
              radius: 50,
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.name ??
                  (isVietnamese ? 'Không xác định' : 'Unknown'),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent),
            ),
            const SizedBox(height: 10),
            if (_userId != null)
              Text(
                '${isVietnamese ? 'Mã người dùng' : 'User ID'}: $_userId',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.pinkAccent),
                  onPressed: _decrementQuantity,
                ),
                Text('$_quantity', style: const TextStyle(fontSize: 20)),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.pinkAccent),
                  onPressed: _incrementQuantity,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${isVietnamese ? 'Tổng giá' : 'Total Price'}: ${(widget.totalPrice * _quantity).toStringAsFixed(2)} VNĐ',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText:
                    isVietnamese ? 'Địa chỉ giao hàng' : 'Shipping Address',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _paymentMethodController,
              decoration: InputDecoration(
                labelText:
                    isVietnamese ? 'Phương thức thanh toán' : 'Payment Method',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: placeOrder,
              child: Text(
                isVietnamese ? 'Xác nhận Đặt hàng' : 'Confirm Order',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
