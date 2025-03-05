import 'dart:math';
import 'package:flutter/material.dart';
import 'package:trinhtuandan_nhom3_2180602115/services/user_service.dart';
import 'package:trinhtuandan_nhom3_2180602115/services/order_service.dart';
import 'package:trinhtuandan_nhom3_2180602115/screens/history_order_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trinhtuandan_nhom3_2180602115/screens/login_screen.dart';
import 'notification_screen.dart';
import 'language_screen.dart';
import 'package:trinhtuandan_nhom3_2180602115/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userId = "Loading...";
  String _profileImage =
      'https://randomuser.me/api/portraits/women/${Random().nextInt(100)}.jpg';
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final OrderService _orderService = OrderService();
  int _notificationCount = 0;
  String _selectedLanguage = 'Tiếng Việt';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadNotificationCount();
    _loadLanguage();
  }

  Future<void> _loadUserData() async {
    try {
      String username = await _userService.getUsername();
      setState(() {
        _userId = username.isNotEmpty ? username : 'Chưa có tên người dùng';
      });
    } catch (e) {
      setState(() {
        _userId = 'Unknown';
      });
    }
  }

  Future<void> _loadNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationCount = prefs.getInt('notification_count') ?? 0;
    });
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'Tiếng Việt';
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isRemoved = await prefs.remove('jwt_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _refreshLanguage(String newLanguage) {
    setState(() {
      _selectedLanguage = newLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';
    return Scaffold(
      appBar: AppBar(
        title: Text(isVietnamese ? '🌸 Hồ Sơ Cá Nhân 🌸' : '🌸 Profile 🌸'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 20),
              _buildTitleBar(isVietnamese
                  ? '✨ Cài đặt tài khoản ✨'
                  : '✨ Account Settings ✨'),
              _buildSettingsList(context, isVietnamese),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(_profileImage),
        ),
        const SizedBox(height: 16),
        Text(
          _userId,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent),
        ),
      ],
    );
  }

  Widget _buildTitleBar(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, bool isVietnamese) {
    return Column(
      children: [
        _buildSettingsListItem(Icons.person,
            isVietnamese ? 'Chỉnh sửa hồ sơ' : 'Edit Profile', () {}),
        _buildSettingsListItem(
            Icons.history, isVietnamese ? 'Lịch sử đơn hàng' : 'Order History',
            () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryOrderScreen()),
          );
        }),
        _buildSettingsListItem(Icons.language,
            isVietnamese ? 'Thay đổi Ngôn Ngữ' : 'Change Language', () async {
          final newLanguage = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LanguageScreen(onLanguageChanged: _refreshLanguage)),
          );
          if (newLanguage != null) {
            _refreshLanguage(newLanguage);
          }
        }),
        _buildSettingsListItem(
            Icons.notifications, isVietnamese ? 'Thông Báo' : 'Notifications',
            () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          );
        }),
        _buildSettingsListItem(
            Icons.logout, isVietnamese ? 'Đăng Xuất' : 'Logout', () {
          _logout(context);
        }),
      ],
    );
  }

  Widget _buildSettingsListItem(
      IconData icon, String title, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.pinkAccent),
        title: Text(title, style: const TextStyle(color: Colors.pinkAccent)),
        onTap: onTap,
      ),
    );
  }
}
