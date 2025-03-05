import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;

  LanguageScreen({required this.onLanguageChanged});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
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

  Future<void> _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      _selectedLanguage = language;
    });
    widget.onLanguageChanged(language);
    Navigator.pop(context, language);
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = _selectedLanguage == 'Tiếng Việt';

    return Scaffold(
      appBar: AppBar(
        title: Text(isVietnamese ? 'Chọn Ngôn Ngữ' : 'Select Language'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Tiếng Việt'),
            trailing: _selectedLanguage == 'Tiếng Việt'
                ? const Icon(Icons.check, color: Colors.pinkAccent)
                : null,
            onTap: () => _saveLanguage('Tiếng Việt'),
          ),
          ListTile(
            title: const Text('English'),
            trailing: _selectedLanguage == 'English'
                ? const Icon(Icons.check, color: Colors.pinkAccent)
                : null,
            onTap: () => _saveLanguage('English'),
          ),
        ],
      ),
    );
  }
}
