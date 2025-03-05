import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trinhtuandan_nhom3_2180602115/services/auth_service.dart';
import 'package:trinhtuandan_nhom3_2180602115/models/cartdetail.dart';

class CartService {
  final String cartApiUrl =
      'https://earlymintbook2.conveyor.cloud/api/CartsApi';
  final String cartDetailsApiUrl =
      'https://earlymintbook2.conveyor.cloud/api/CartDetailsApi';
  final AuthService _authService = AuthService();
  int? _cartId;

  /// Kiểm tra nếu có giỏ hàng nào đã tồn tại, trả về cartId nếu có
  Future<int?> getCurrentCartId() async {
    if (_cartId != null) return _cartId;

    try {
      String? token = await _authService.getToken();
      if (token == null) throw Exception('Token không tồn tại.');

      final response = await http.get(
        Uri.parse(cartApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> carts = json.decode(response.body);
        if (carts.isNotEmpty) {
          _cartId = carts.last['id'];
          return _cartId;
        }
      } else {
        throw Exception(
            'Không thể lấy thông tin giỏ hàng. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy giỏ hàng: $e');
    }
    return null;
  }

  /// Tạo giỏ hàng mới
  Future<int?> createCart() async {
    try {
      String? token = await _authService.getToken();
      if (token == null) throw Exception('Token không tồn tại.');

      String? userId = await _authService.getUserId();
      if (userId == null) throw Exception('UserId không tồn tại.');

      final response = await http.post(
        Uri.parse(cartApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"userId": userId}),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _cartId = data['id'];
        return _cartId;
      } else {
        throw Exception(
            'Không thể tạo giỏ hàng. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi tạo giỏ hàng: $e');
    }
  }

  /// Thêm sản phẩm vào giỏ hàng
  Future<void> addProductToCart(int cartId, int productId) async {
    try {
      String? token = await _authService.getToken();
      if (token == null) throw Exception('Token không tồn tại.');

      final response = await http.post(
        Uri.parse(cartDetailsApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "cartId": cartId,
          "productId": productId,
          "quantity": 1,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Không thể thêm sản phẩm vào giỏ hàng. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi thêm sản phẩm vào giỏ hàng: $e');
    }
  }

  /// Lấy danh sách sản phẩm
  Future<List<dynamic>> fetchProducts(String productsUrl) async {
    try {
      final response = await http.get(Uri.parse(productsUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Không thể lấy danh sách sản phẩm. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách sản phẩm: $e');
    }
  }

  /// Lấy chi tiết giỏ hàng
  Future<List<Cartdetail>> getCartDetails() async {
    try {
      String? token = await _authService.getToken();
      if (token == null) throw Exception('Token không tồn tại.');

      final response = await http.get(
        Uri.parse(cartDetailsApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Cartdetail.fromJson(item)).toList();
      } else {
        throw Exception(
            'Không thể lấy chi tiết giỏ hàng. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy chi tiết giỏ hàng: $e');
    }
  }

  /// Xóa CartDetail
  Future<void> deleteCartDetail(int cartDetailId) async {
    try {
      String? token = await _authService.getToken();
      if (token == null) throw Exception('Token không tồn tại.');

      final response = await http.delete(
        Uri.parse('$cartDetailsApiUrl/$cartDetailId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
            'Không thể xóa CartDetail. Mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi xóa CartDetail: $e');
    }
  }
}
