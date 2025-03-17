import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/student_home_screen.dart';
import 'screens/admin_home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/', // Start with the WelcomeScreen
    routes: {
      '/': (context) => WelcomeScreen(),
      '/login': (context) => LoginScreen(),
      '/admin': (context) => AdminHomeScreen(),
      '/student': (context) => StudentHomeScreen(),
    },
    onGenerateRoute: (settings) {
      if (settings.name == '/register') {
        final role = settings.arguments as String?;
        if (role != null) {
          return MaterialPageRoute(
            builder: (context) => RegisterScreen(role: role),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text('Error: Role not provided'),
              ),
            ),
          );
        }
      }
      return null;
    },
  ));
}
