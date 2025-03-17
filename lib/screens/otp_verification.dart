import 'package:flutter/material.dart';
import 'dart:math';
import 'login_screen.dart'; // Import the login screen
import '../services/auth_service.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email, password, name, extraField, role;

  OTPVerificationScreen({
    required this.email,
    required this.password,
    required this.name,
    required this.extraField,
    required this.role,
  });

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  int _generatedOTP = 0;
  final TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _generateOTP();
  }

  void _generateOTP() {
    Random random = Random();
    _generatedOTP = 100000 + random.nextInt(900000); // Generates a 6-digit OTP
    print("Generated OTP: $_generatedOTP"); // TODO: Replace with actual email sending
  }

  void _verifyOTP() async {
    if (_otpController.text == _generatedOTP.toString()) {
      // ✅ Register the user after OTP verification
      bool isRegistered = await _authService.registerUser(
        widget.email, widget.password, widget.role
      );

      if (isRegistered) {
        _showSuccessDialog(); // Show success dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User already exists! Try logging in.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP! Try Again.")),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents user from closing the popup manually
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("OTP Verified Successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _redirectToLogin();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _redirectToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter the OTP sent to your email (${widget.email})",
                  textAlign: TextAlign.center,
                ),
                if (widget.role == "admin")
                  Text("Council Name: ${widget.extraField}"),
                if (widget.role == "student")
                  Text("Branch Name: ${widget.extraField}"),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "OTP"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _verifyOTP,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Verify OTP", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
