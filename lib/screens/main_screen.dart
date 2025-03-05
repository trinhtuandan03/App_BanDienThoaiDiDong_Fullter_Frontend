import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'product_screen.dart';
import 'cart_screen.dart';
import 'blog_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Hàm lấy màn hình hiện tại
  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(); // Trang Home
      case 1:
        return const ProductScreen(); // Danh sách video trực tiếp
      case 2:
        return CartScreen(); // Trang Account
      case 3:
        return  BlogScreen(); // Trang Market
      case 4:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }

  // Custom function để thay đổi màu biểu tượng active/inactive
  Color _getIconColor(int index) {
    return _currentIndex == index ? Colors.blue : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentScreen(), // Gọi hàm để hiển thị màn hình tương ứng
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cập nhật chỉ số khi chuyển tab
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _getIconColor(0)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined, color: _getIconColor(1)),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: _getIconColor(2)),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper, color: _getIconColor(3)),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: _getIconColor(4)),
            label: 'Hồ Sơ',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        elevation: 10,
      ),
    );
  }
}
