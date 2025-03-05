import 'package:flutter/material.dart';
import 'package:trinhtuandan_nhom3_2180602115/models/product.dart';
import 'package:trinhtuandan_nhom3_2180602115/services/cart_service.dart';
import 'package:trinhtuandan_nhom3_2180602115/services/category_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final CartService _cartService = CartService();
  final CategoryService _categoryService = CategoryService();
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

  Future<void> addToCart(BuildContext context) async {
    try {
      int? existingCartId = await _cartService.getCurrentCartId();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int notificationCount = (prefs.getInt('notification_count') ?? 0) + 1;
      await prefs.setInt('notification_count', notificationCount);

      List<String> notifications = prefs.getStringList('notifications') ?? [];
      notifications.add(_selectedLanguage == 'Tiếng Việt'
          ? 'Sản phẩm "${widget.product.name}" đã được thêm vào giỏ hàng!'
          : 'Product "${widget.product.name}" has been added to the cart!');
      await prefs.setStringList('notifications', notifications);

      if (existingCartId == null) {
        int? newCartId = await _cartService.createCart();
        if (newCartId != null) {
          await _cartService.addProductToCart(newCartId, widget.product.id!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(_selectedLanguage == 'Tiếng Việt'
                    ? 'Giỏ hàng mới đã được tạo và sản phẩm đã được thêm!'
                    : 'A new cart was created and the product was added!')),
          );
        } else {
          throw Exception(_selectedLanguage == 'Tiếng Việt'
              ? 'Không thể tạo giỏ hàng.'
              : 'Unable to create cart.');
        }
      } else {
        await _cartService.addProductToCart(existingCartId, widget.product.id!);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                _selectedLanguage == 'Tiếng Việt' ? 'Lỗi: $e' : 'Error: $e')),
      );
    }
  }

  Future<String> getCategoryName() async {
    return await _categoryService
        .getCategoryNameById(widget.product.categoryId ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';
    return Scaffold(
      appBar: AppBar(
        title: Text(isVietnamese
            ? widget.product.name ?? 'Chi tiết sản phẩm'
            : widget.product.name ?? 'Product Details'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: PageView(
                children: [
                  Image.network(widget.product.image1 ?? '', fit: BoxFit.cover),
                  Image.network(widget.product.image2 ?? '', fit: BoxFit.cover),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.product.name ??
                  (isVietnamese ? 'Không có tên' : 'No name'),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${isVietnamese ? 'Giá' : 'Price'}: ${widget.product.price?.toStringAsFixed(2)} VNĐ',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 10),
            FutureBuilder<String>(
              future: getCategoryName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(isVietnamese
                      ? 'Lỗi khi tải loại sản phẩm'
                      : 'Error loading category');
                } else {
                  return Text(
                    '${isVietnamese ? 'Loại sản phẩm' : 'Category'}: ${snapshot.data}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              '${isVietnamese ? 'Mô tả' : 'Description'}: ${widget.product.description ?? (isVietnamese ? 'Không có mô tả' : 'No description')}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () => addToCart(context),
              child: Text(
                isVietnamese ? 'Thêm vào giỏ hàng' : 'Add to Cart',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
