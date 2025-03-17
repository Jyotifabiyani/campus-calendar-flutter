import 'package:flutter/material.dart';
import 'package:campus_calendar/screens/register_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Role")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen(role: "Admin")),
              ),
              child: Text("Register as Admin"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen(role: "Student")), // ✅ FIXED
              ),
              child: Text("Register as Student"),
            ),
          ],
        ),
      ),
    );
  }
}
