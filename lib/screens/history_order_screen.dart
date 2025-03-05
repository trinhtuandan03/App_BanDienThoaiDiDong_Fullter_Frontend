import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trinhtuandan_nhom3_2180602115/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryOrderScreen extends StatefulWidget {
  const HistoryOrderScreen({super.key});

  @override
  _HistoryOrderScreenState createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String _selectedLanguage = 'Tiếng Việt';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _fetchOrders();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'Tiếng Việt';
    });
  }

  Future<void> _fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('https://earlymintbook2.conveyor.cloud/api/OrderApi'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _orders = data
              .map((item) => Order(
                    id: item['id'] ?? 0,
                    userId: item['userId'],
                    orderDate: DateTime.parse(item['orderDate']),
                    orderStatus: item['orderStatus'],
                    totalPrice: (item['totalPrice'] as num).toDouble(),
                    paymentMethod: item['paymentMethod'],
                    shippingAddress: item['shippingAddress'],
                  ))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Lỗi khi tải danh sách đơn hàng: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_selectedLanguage == 'Tiếng Việt'
                ? 'Lỗi khi tải đơn hàng: $e'
                : 'Error loading orders: $e')),
      );
    }
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_selectedLanguage == 'Tiếng Việt'
            ? 'Chi Tiết Đơn Hàng'
            : 'Order Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                '${_selectedLanguage == 'Tiếng Việt' ? 'Mã Đơn Hàng: ' : 'Order ID: '} ${order.id}'),
            Text(
                '${_selectedLanguage == 'Tiếng Việt' ? 'Tổng Giá: ' : 'Total Price: '} ${order.totalPrice.toStringAsFixed(2)} VNĐ'),
            Text(
                '${_selectedLanguage == 'Tiếng Việt' ? 'Trạng Thái: ' : 'Status: '} ${order.orderStatus}'),
            Text(
                '${_selectedLanguage == 'Tiếng Việt' ? 'Phương Thức Thanh Toán: ' : 'Payment Method: '} ${order.paymentMethod}'),
            Text(
                '${_selectedLanguage == 'Tiếng Việt' ? 'Địa Chỉ Giao Hàng: ' : 'Shipping Address: '} ${order.shippingAddress}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_selectedLanguage == 'Tiếng Việt' ? 'Đóng' : 'Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';
    return Scaffold(
      appBar: AppBar(
        title: Text(isVietnamese ? '🛒 Lịch Sử Đơn Hàng' : '🛒 Order History'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(
                  child: Text(isVietnamese
                      ? 'Không có đơn hàng nào.'
                      : 'No orders available.'))
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      child: ListTile(
                        title: Text(isVietnamese
                            ? 'Mã Đơn Hàng: ${order.id}'
                            : 'Order ID: ${order.id}'),
                        subtitle: Text(isVietnamese
                            ? 'Tổng Giá: ${order.totalPrice.toStringAsFixed(2)} VNĐ\nTrạng Thái: ${order.orderStatus}'
                            : 'Total Price: ${order.totalPrice.toStringAsFixed(2)} VNĐ\nStatus: ${order.orderStatus}'),
                        trailing: const Icon(Icons.receipt_long,
                            color: Colors.pinkAccent),
                        onTap: () => _showOrderDetails(order),
                      ),
                    );
                  },
                ),
    );
  }
}
