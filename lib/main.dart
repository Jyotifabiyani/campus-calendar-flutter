import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/student_home_screen.dart';
import 'screens/admin_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD7NQAAmQzJijuRoD47dGR0T_Y2FOOioes", // Your Web API Key
      authDomain: "mad-project-8b9fd.firebaseapp.com", // authDomain format: "<PROJECT_ID>.firebaseapp.com"
      projectId: "mad-project-8b9fd", // Your Project ID
      storageBucket: "mad-project-8b9fd.appspot.com", // Storage Bucket (if used)
      messagingSenderId: "99682742234", // Messaging Sender ID (if used)
      appId: "1:99682742234:web:7e1e82dc8eb156b7eadea3", // Your App ID
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
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
                body: Center(child: Text('Error: Role not provided')),
              ),
            );
          }
        }
        return null;
      },
    );
  }
}
