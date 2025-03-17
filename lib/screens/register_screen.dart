import 'package:flutter/material.dart';
import 'otp_verification.dart'; // Import the OTP verification screen
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final String role; // ✅ Role passed from RoleSelectionScreen

  const RegisterScreen({Key? key, required this.role}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _councilOrBranchController = TextEditingController();
  final AuthService _authService = AuthService();

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Navigate to OTP verification screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
            extraField: _councilOrBranchController.text,
            role: widget.role,
          ),
        ),
      );
    }
  }

  // Validate email domain
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    if (!value.endsWith("@ves.ac.in")) {
      return "Please enter VES-ID only";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.role == "Admin" ? "Register as Admin" : "Register as Student"), // ✅ Dynamic title
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: _validateEmail, // ✅ Validate email domain
              ),

              // Council Name for Admin / Branch Name for Student
              if (widget.role == "Admin") 
                TextFormField(
                  controller: _councilOrBranchController,
                  decoration: InputDecoration(labelText: "Council Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter council name";
                    }
                    return null;
                  },
                ),
              if (widget.role == "Student") 
                TextFormField(
                  controller: _councilOrBranchController,
                  decoration: InputDecoration(labelText: "Branch Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter branch name";
                    }
                    return null;
                  },
                ),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Register Button
              Center(
                child: ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Register", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
