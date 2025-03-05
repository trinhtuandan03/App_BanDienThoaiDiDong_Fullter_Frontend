import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinhtuandan_nhom3_2180602115/screens/login_screen.dart'; // Import màn hình đăng nhập

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  // Hàm đăng xuất
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token'); // Xóa token khỏi SharedPreferences

    // Chuyển hướng đến màn hình Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Hiển thị hộp thoại xác nhận đăng xuất
  Future<void> _showLogoutDialog(BuildContext context) async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text(
              'Bạn có muốn đăng xuất khỏi tài khoản hiện tại không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Người dùng chọn "Không"
              },
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Người dùng chọn "Có"
              },
              child: const Text('Có'),
            ),
          ],
        );
      },
    );

    // Nếu người dùng chọn "Có", thực hiện đăng xuất
    if (confirmLogout == true) {
      await _logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(
                context), // Gọi hàm hiển thị hộp thoại xác nhận
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome, Admin!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
