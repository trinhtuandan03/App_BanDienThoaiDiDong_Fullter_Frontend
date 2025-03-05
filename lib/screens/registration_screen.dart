import 'package:flutter/material.dart';
import 'package:trinhtuandan_nhom3_2180602115/utils/auth.dart';
import 'package:trinhtuandan_nhom3_2180602115/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _initialsController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
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

  Future<void> _handleRegister() async {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _initialsController.text.isEmpty ||
        _roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_selectedLanguage == 'Tiếng Việt'
              ? 'Vui lòng nhập đầy đủ thông tin'
              : 'Please enter all required information.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Map<String, dynamic> result = await Auth.register(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      initials: _initialsController.text,
      role: _roleController.text,
      phone: _phoneController.text,
    );

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_selectedLanguage == 'Tiếng Việt'
              ? 'Đăng ký thành công!'
              : 'Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      String errorMessage = result['message'] ??
          (_selectedLanguage == 'Tiếng Việt'
              ? 'Đăng ký thất bại'
              : 'Registration failed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  isVietnamese ? 'Đăng ký tài khoản' : 'Register an Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[800],
                  ),
                ),
                const SizedBox(height: 20),
                ..._buildTextFields(),
                const SizedBox(height: 20),
                _buildRegisterButton(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isVietnamese
                        ? "Đã có tài khoản? "
                        : "Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        isVietnamese ? 'Đăng nhập' : 'Login',
                        style: const TextStyle(color: Colors.pink),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';
    return [
      _buildTextField(
          _usernameController, isVietnamese ? 'Tên người dùng' : 'Username'),
      const SizedBox(height: 12),
      _buildTextField(_emailController, 'Email'),
      const SizedBox(height: 12),
      _buildTextField(
          _phoneController, isVietnamese ? 'Số điện thoại' : 'Phone Number'),
      const SizedBox(height: 12),
      _buildPasswordField(),
      const SizedBox(height: 12),
      _buildTextField(
          _initialsController, isVietnamese ? 'Ký tự viết tắt' : 'Initials'),
      const SizedBox(height: 12),
      _buildTextField(_roleController,
          isVietnamese ? 'Vai trò (Admin/User)' : 'Role (Admin/User)'),
    ];
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPasswordField() {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: isVietnamese ? 'Mật khẩu' : 'Password',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.pink,
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : Text(
                isVietnamese ? 'Đăng ký' : 'Register',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
