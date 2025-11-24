import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/signup_view.dart';
import 'views/home_view.dart';
import 'views/forgot_password_view.dart';

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MagicSlides',
      theme: ThemeData(
        primaryColor: Color(0xFFfabd05),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Color(0xFFF5F5F5),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
        '/home': (context) => const HomeView(),
        '/forgot_password': (context) => const ForgotPasswordView(),
      },
    );
  }
}
