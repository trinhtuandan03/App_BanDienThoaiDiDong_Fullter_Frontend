import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trinhtuandan_nhom3_2180602115/models/product.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  String _selectedLanguage = 'Tiếng Việt';

  final TextEditingController searchController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  bool showPriceFilter = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'Tiếng Việt';
    });
  }

  Future<void> fetchProducts() async {
    const String baseUrl =
        'https://earlymintbook2.conveyor.cloud/api/ProductApi';
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
          filteredProducts = products;
          isLoading = false;
        });
      } else {
        throw Exception(_selectedLanguage == 'Tiếng Việt'
            ? 'Không thể tải sản phẩm'
            : 'Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                _selectedLanguage == 'Tiếng Việt' ? 'Lỗi: $e' : 'Error: $e')),
      );
    }
  }

  void filterProducts() {
    String query = searchController.text.toLowerCase();
    double? minPrice = double.tryParse(minPriceController.text);
    double? maxPrice = double.tryParse(maxPriceController.text);

    setState(() {
      filteredProducts = products.where((product) {
        bool matchesName = product.name?.toLowerCase().contains(query) ?? false;
        bool matchesPrice = true;

        if (minPrice != null && maxPrice != null) {
          matchesPrice = product.price != null &&
              product.price! >= minPrice &&
              product.price! <= maxPrice;
        }

        return matchesName && matchesPrice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        elevation: 2,
        title: Text(
          isVietnamese ? "✨ Danh Sách Sản Phẩm ✨" : "✨ Product List ✨",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.pink,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.pink),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText:
                          isVietnamese ? 'Tìm kiếm sản phẩm' : 'Search Product',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) => filterProducts(),
                  ),
                ),
                IconButton(
                  icon: Icon(showPriceFilter
                      ? Icons.filter_alt_off
                      : Icons.filter_alt),
                  onPressed: () {
                    setState(() {
                      showPriceFilter = !showPriceFilter;
                    });
                  },
                ),
              ],
            ),
          ),
          if (showPriceFilter)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minPriceController,
                      decoration: InputDecoration(
                        labelText: isVietnamese ? 'Giá từ' : 'Min Price',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => filterProducts(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: maxPriceController,
                      decoration: InputDecoration(
                        labelText: isVietnamese ? 'Giá đến' : 'Max Price',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => filterProducts(),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          isVietnamese
                              ? '😢 Không có sản phẩm nào.'
                              : '😢 No products available.',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20.0)),
                                    child: product.image1 != null
                                        ? Image.network(
                                            product.image1!,
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.image,
                                            size: 150, color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          product.name ??
                                              (isVietnamese
                                                  ? 'Không có tên'
                                                  : 'No Name'),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${isVietnamese ? 'Giá' : 'Price'}: ${product.price?.toStringAsFixed(2)} VNĐ',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
