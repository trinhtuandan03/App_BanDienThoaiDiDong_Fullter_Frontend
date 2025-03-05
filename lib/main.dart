import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trinhtuandan_nhom3_2180602115/screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'package:trinhtuandan_nhom3_2180602115/screens/otp_verification_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baos bán phones',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
        '/otp': (context) => const OtpVerificationScreen(),
      },
    );
  }
}
