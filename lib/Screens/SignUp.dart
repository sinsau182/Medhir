import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medhir/Screens/Login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String _registerUrl = 'http://13.201.224.161:5000/register';

  // To store the email passed from the HomeScreen
  String? emailFromHome;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the passed email argument, if any
    emailFromHome = ModalRoute
        .of(context)
        ?.settings
        .arguments as String?;
    if (emailFromHome != null) {
      _emailController.text =
      emailFromHome!; // Pre-fill the email field if provided
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _registerUser();
    }
  }

  Future<void> _registerUser() async {
    final String fname = _fnameController.text;
    final String lname = _lnameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse(_registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fname': fname,
          'lname': lname,
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
          MaterialPageRoute(builder: (context) => MainApp()),
        );
      } else {
        final errorMessage = json.decode(response.body)['message'] ??
            'Registration failed';
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Gradient Background
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
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Row(
                      children: [
                        Text(
                          'Already Registered? ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildInputField(
                          controller: _fnameController,
                          hintText: 'First Name',
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 20.h),
                        _buildInputField(
                          controller: _lnameController,
                          hintText: 'Last Name',
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 20.h),
                        _buildInputField(
                          controller: _emailController,
                          hintText: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          isReadOnly: true, // Make the email field read-only
                        ),

                        SizedBox(height: 20.h),
                        _buildInputField(
                          controller: _passwordController,
                          hintText: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: true,
                        ),
                        SizedBox(height: 20.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        SizedBox(
                          width: 0.7.sw,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color(0xFFFFCC00),
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                  Colors.white),
                              minimumSize: MaterialStateProperty.all(
                                  Size(double.infinity, 50.h)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 24.sp,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    bool isReadOnly = false, // New parameter for read-only state
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: isReadOnly,
      // Make the field read-only
      decoration: InputDecoration(
        filled: true,
        fillColor: isReadOnly ? Color(0xFFE0E0E0) : Color(0xFFF8F9FA),
        // Light grey if read-only
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      ),
      style: TextStyle(fontSize: 14.sp, color: Colors.black),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
    );
  }
}