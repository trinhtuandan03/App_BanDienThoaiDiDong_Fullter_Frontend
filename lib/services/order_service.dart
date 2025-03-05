import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trinhtuandan_nhom3_2180602115/models/order.dart';
import 'package:trinhtuandan_nhom3_2180602115/models/orderdetail.dart';
import 'package:trinhtuandan_nhom3_2180602115/services/auth_service.dart';

class OrderService {
  final String orderApiUrl =
      'https://earlymintbook2.conveyor.cloud/api/OrderApi';
  final String orderDetailApiUrl =
      'https://earlymintbook2.conveyor.cloud/api/OrderDetailApi';
  final AuthService _authService = AuthService();

  // Tạo đơn hàng mới
  Future<int?> createOrder(Order order) async {
    try {
      String? token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token không hợp lệ.');
      }

      final response = await http.post(
        Uri.parse(orderApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(order.toJson()),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['id']; // Trả về id đơn hàng để tạo chi tiết
      } else {
        print('Lỗi khi tạo đơn hàng: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi từ Flutter: $e');
      return null;
    }
  }

  // Tạo chi tiết đơn hàng
  Future<bool> createOrderDetail(Orderdetail Orderdetail) async {
    try {
      String? token = await _authService.getToken();
      if (token == null) throw Exception('Token không hợp lệ.');

      final response = await http.post(
        Uri.parse(orderDetailApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(Orderdetail.toJson()),
      );

      if (response.statusCode == 201) {
        print('Chi tiết đơn hàng đã được tạo thành công.');
        return true;
      } else {
        print('Lỗi khi tạo chi tiết đơn hàng: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi từ Flutter: $e');
      return false;
    }
  }
}
