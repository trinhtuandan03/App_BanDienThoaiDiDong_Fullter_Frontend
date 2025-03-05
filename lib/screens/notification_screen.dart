import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getStringList('notifications') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌟 Thông Báo 🌟'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        elevation: 5,
      ),
      body: _notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.notifications_off, size: 100, color: Colors.pinkAccent),
            SizedBox(height: 20),
            Text('Không có thông báo nào!',
                style: TextStyle(fontSize: 20, color: Colors.pinkAccent)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.pinkAccent),
              title: Text(
                _notifications[index],
                style: const TextStyle(fontSize: 16, color: Colors.pinkAccent),
              ),
            ),
          );
        },
      ),
    );
  }
}
