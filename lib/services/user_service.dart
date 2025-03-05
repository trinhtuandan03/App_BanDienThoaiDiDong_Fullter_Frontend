import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'Unknown';  // Corrected to get the stored value
    print("Username retrieved: $username");
    return username;
  }
  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? 'unknown_user';
    print("UserId retrieved: $userId");
    return userId;
  }
}
