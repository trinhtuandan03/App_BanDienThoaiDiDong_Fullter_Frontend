import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trinhtuandan_nhom3_2180602115/models/product.dart';
import 'package:trinhtuandan_nhom3_2180602115/models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLanguage = 'Tiếng Việt';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'Tiếng Việt';
    });
  }

  Future<List<Product>> fetchProducts() async {
    const String baseUrl =
        'https://earlymintbook2.conveyor.cloud/api/ProductApi';
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception(_selectedLanguage == 'Tiếng Việt'
          ? 'Không thể tải sản phẩm'
          : 'Failed to load products');
    }
  }

  Future<List<Category>> fetchCategories() async {
    const String baseUrl =
        'https://earlymintbook2.conveyor.cloud/api/CategoriesApi';
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception(_selectedLanguage == 'Tiếng Việt'
          ? 'Không thể tải danh mục'
          : 'Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isVietnamese ? 'Trang chủ' : 'Home',
          style: const TextStyle(
              fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Category>>(
        future: fetchCategories(),
        builder: (context, categorySnapshot) {
          if (categorySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (categorySnapshot.hasError) {
            return Center(
                child: Text(isVietnamese
                    ? 'Lỗi: ${categorySnapshot.error}'
                    : 'Error: ${categorySnapshot.error}'));
          } else if (!categorySnapshot.hasData ||
              categorySnapshot.data!.isEmpty) {
            return Center(
                child: Text(isVietnamese
                    ? 'Không có danh mục nào.'
                    : 'No categories available.'));
          } else {
            return FutureBuilder<List<Product>>(
              future: fetchProducts(),
              builder: (context, productSnapshot) {
                if (productSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productSnapshot.hasError) {
                  return Center(
                      child: Text(isVietnamese
                          ? 'Lỗi: ${productSnapshot.error}'
                          : 'Error: ${productSnapshot.error}'));
                } else if (!productSnapshot.hasData ||
                    productSnapshot.data!.isEmpty) {
                  return Center(
                      child: Text(isVietnamese
                          ? 'Không có sản phẩm nào.'
                          : 'No products available.'));
                } else {
                  final categories = categorySnapshot.data!;
                  final products = productSnapshot.data!;

                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final categoryProducts = products
                          .where((p) => p.categoryId == category.id)
                          .toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              category.name ??
                                  (isVietnamese
                                      ? 'Danh mục không xác định'
                                      : 'Unknown Category'),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                          ...categoryProducts.map((product) => Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(10.0),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      product.image1 ?? '',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    product.name ??
                                        (isVietnamese
                                            ? 'Không có tên'
                                            : 'No name'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    product.description ??
                                        (isVietnamese
                                            ? 'Không có mô tả'
                                            : 'No description'),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Text(
                                    '${product.price} VND',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
