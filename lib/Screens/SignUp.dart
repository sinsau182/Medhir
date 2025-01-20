import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medhir/Screens/Login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final String _registerUrl = 'http://13.201.224.161:5000/register';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text == _confirmPasswordController.text) {
        _registerUser();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
      }
    }
  }

  Future<void> _registerUser() async {
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse(_registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful! Please log in.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        final errorMessage = json.decode(response.body)['message'] ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final lightGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0A1128), Color(0xFF1B263B), Color(0xFFEAEAEA)],
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: lightGradient,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // "Sign Up" Heading
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [
                              Color(0xFFFFD700), // Gold
                              Color(0xFFFFFFFF), // White
                            ],
                          ).createShader(Rect.fromLTWH(0, 0, 300, 100)),
                        shadows: [
                          Shadow(
                            offset: Offset(3, 3),
                            blurRadius: 6.0,
                            color: Color(0xFF1B263B),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Subtitle
                    Text(
                      'Welcome to Medhir Family',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    // Input Fields
                    _buildInputField(
                      controller: _usernameController,
                      hintText: 'Username',
                      icon: Icons.person_outline,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    _buildInputField(
                      controller: _emailController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    _buildInputField(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    _buildInputField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Sign Up Button
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0xFF003566)),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 55)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Or Sign Up With
                    Text(
                      'Or sign up with',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xFFEAEAEA),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Social Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialLoginButton(
                          label: 'Google',
                          icon: Icons.g_mobiledata,
                          onPressed: () {
                            // Add Google sign-up logic
                          },
                        ),
                        SizedBox(width: screenWidth * 0.05),
                        _socialLoginButton(
                          label: 'Facebook',
                          icon: Icons.facebook,
                          onPressed: () {
                            // Add Facebook sign-up logic
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Already have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFEAEAEA),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFEA41D), // New Yellow
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFF8F9FA),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Color(0xFF003566), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      ),
      style: TextStyle(fontSize: 16, color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
    );
  }

  Widget _socialLoginButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1B263B),
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
