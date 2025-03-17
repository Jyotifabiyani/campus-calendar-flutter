import '../database/db_helper.dart';
import '../models/user_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final Map<String, Map<String, String>> _users = {}; // Mock database

  Future<bool> registerUser(String email, String password, String role) async {
  if (_users.containsKey(email)) {
    return false; // User already exists
  }

  _users[email] = {"password": password, "role": role};

  // ✅ Store role in SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("$email-role", role); 

  // ✅ Debugging: Print stored role to check
  print("Stored Role for $email: ${prefs.getString("$email-role")}");

  return true;
}

  Future<String?> authenticateUser(String email, String password) async {
  if (_users.containsKey(email) && _users[email]!["password"] == password) {
    final prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString("$email-role");

    // ✅ Debugging: Print retrieved role
    print("Retrieved Role for $email: $role");

    return role;
  }
  return null; // Invalid credentials
}

}
