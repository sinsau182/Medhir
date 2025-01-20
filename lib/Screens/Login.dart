import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medhir/Screens/SignUp.dart';
import 'app.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  bool rememberMe = false;

  Future<void> loginUser(String email, String password, BuildContext context) async {
    final url = Uri.parse('http://13.201.224.161:5000/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        if (rememberMe) {
          await prefs.setString('email', email);
          await prefs.setString('password', password);
        } else {
          await prefs.remove('email');
          await prefs.remove('password');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainApp()),
        );
      } else {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${errorData['message'] ?? response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
  }

  Future<void> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final lightGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0A1128), // Dark navy blue
        Color(0xFF1B263B), // Lighter navy blue
        Color(0xFFEAEAEA), // Subtle off-white
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            width: double.infinity,
            height: screenHeight,
            decoration: BoxDecoration(gradient: lightGradient),
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Fancy Login Heading
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [Color(0xFFDAA520), Color(0xFFEAEAEA)],
                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 4.0,
                            color: Color(0xFF1B263B),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Manage Your Business Efficiently',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xFFEAEAEA),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    // Email TextField
                    TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Password TextField with Eye Icon
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Remember Me and Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                              activeColor: Color(0xFFDAA520),
                            ),
                            Text(
                              'Remember Me',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFEAEAEA),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle Forgot Password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFDAA520),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Login Button
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: ElevatedButton(
                        onPressed: () {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          if (email.isNotEmpty && password.isNotEmpty) {
                            loginUser(email, password, context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill in all fields')),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0xFF1B263B)),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    // Rest of your code...
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
