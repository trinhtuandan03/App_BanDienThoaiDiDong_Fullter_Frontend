import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trinhtuandan_nhom3_2180602115/models/category.dart';

class CategoryService {
  final String _baseUrl =
      'https://earlymintbook2.conveyor.cloud/api/CategoriesApi';

  Future<String> getCategoryNameById(int categoryId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$categoryId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final category = Category.fromJson(data);
        return category.name ?? 'Không xác định';
      } else {
        return 'Không xác định'; // Trả về một giá trị mặc định nếu không tìm thấy
      }
    } catch (e) {
      return 'Không xác định'; // Trả về một giá trị mặc định nếu lỗi xảy ra
    }
  }
}
