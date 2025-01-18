import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medhir/Screens/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app.dart';

// TextFieldDecoration Widget
class TextFieldDecoration extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon prefixIcon;

  TextFieldDecoration({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFF8F9FA),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0.r),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(String email, String password, BuildContext context) async {
    final url = Uri.parse('http://13.201.224.161:5000/login');

    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      },
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      Navigator.pop(context); // Dismiss loader

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('authToken', token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainApp()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Dismiss loader in case of error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              // Background gradient
              Container(
                width: double.infinity,
                height: 1.sh,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B2A2F), Color(0xFF14444F)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w, // Proportional horizontal padding
                    vertical: 20.h, // Proportional vertical padding
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      SizedBox(height: 50.h),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 28.sp, // Scaled font size
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),

                  // Illustration image
                  Image.asset(
                    'assets/illustration1.png',
                    width: 200.w,
                    height: 200.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 30.h),

                  // Email TextField
                  TextFieldDecoration(
                    controller: emailController,
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                  ),

                  SizedBox(height: 20.h),

                  // Password TextField
                  TextFieldDecoration(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                  ),

                  SizedBox(height: 30.h),

                  // Login Button
                  SizedBox(
                    width: 0.5.sw, // Button width as 50% of screen width
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
                          backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 204, 170, 0)),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50.h)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0.r),
                            ),
                          ),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text('Sign In', style: TextStyle(fontSize: 16.sp, color: Color(0xFF000000))),
                        SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward, size: 20.sp, color: Color(0xFF000000)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Sign-Up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
        ],
        ),
        );
      },
    );
  }
}
