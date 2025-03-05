import 'package:flutter/material.dart';
import 'package:trinhtuandan_nhom3_2180602115/models/cartdetail.dart';
import 'package:trinhtuandan_nhom3_2180602115/models/product.dart';
import 'package:trinhtuandan_nhom3_2180602115/screens/order_screen.dart';
import 'package:trinhtuandan_nhom3_2180602115/services/cart_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  List<Cartdetail> cartDetails = [];
  Map<int, Product> products = {};
  bool isLoading = true;
  String _selectedLanguage = 'Tiếng Việt';

  @override
  void initState() {
    super.initState();
    fetchCartDetails();
  }

  Future<void> fetchCartDetails() async {
    const String productsUrl =
        'https://earlymintbook2.conveyor.cloud/api/ProductApi';
    try {
      cartDetails = await _cartService.getCartDetails();
      final response = await _cartService.fetchProducts(productsUrl);
      if (response != null) {
        products = {
          for (var item in response)
            Product.fromJson(item).id!: Product.fromJson(item)
        };
      }

      setState(() {
        isLoading = false;
      });
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

  Future<void> deleteCartItem(int cartDetailId) async {
    try {
      await _cartService.deleteCartDetail(cartDetailId);
      setState(() {
        cartDetails.removeWhere((item) => item.id == cartDetailId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_selectedLanguage == 'Tiếng Việt'
                ? 'Xóa sản phẩm thành công'
                : 'Item deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa sản phẩm: $e')),
      );
    }
  }

  Future<void> navigateToOrderScreen(Cartdetail cartDetail) async {
    final product = products[cartDetail.productId]!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(
          product: product,
          quantity: cartDetail.quantity!,
          totalPrice: product.price! * cartDetail.quantity!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';
    return Scaffold(
      appBar: AppBar(
        title: Text(isVietnamese ? '🛍 Giỏ hàng của bạn' : '🛍 Your Cart'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartDetails.isEmpty
              ? Center(
                  child:
                      Text(isVietnamese ? 'Giỏ hàng trống' : 'Cart is empty'))
              : ListView.builder(
                  itemCount: cartDetails.length,
                  itemBuilder: (context, index) {
                    final cartDetail = cartDetails[index];
                    final product = products[cartDetail.productId]!;

                    return Dismissible(
                      key: Key(cartDetail.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete,
                            color: Colors.white, size: 32),
                      ),
                      onDismissed: (direction) {
                        deleteCartItem(cartDetail.id!);
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10.0),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                product.image1?.isNotEmpty == true
                                    ? product.image1!
                                    : 'https://via.placeholder.com/150'),
                          ),
                          title: Text(
                            product.name ??
                                (isVietnamese ? 'Không xác định' : 'Unknown'),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pinkAccent),
                          ),
                          subtitle: Text(isVietnamese
                              ? 'Số lượng: ${cartDetail.quantity}'
                              : 'Quantity: ${cartDetail.quantity}'),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent),
                            onPressed: () => navigateToOrderScreen(cartDetail),
                            child: Text(isVietnamese ? 'Mua' : 'Buy',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
