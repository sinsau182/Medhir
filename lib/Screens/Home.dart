import 'dart:convert'; // for json and jsonDecode
import 'package:http/http.dart' as http; // for http requests
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medhir/ThemeNotifier.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
// Assuming you are using flutter_screenutil for screen sizing

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController credController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool emailExists = false;
  bool isLoggingIn = false;

  // Check if email exists
  Future<bool> isEmailAvailable(String email) async {
    final apiUrl = 'http://13.201.224.161:5000/users/emails';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is List) {
          return responseBody.contains(email);
        } else {
          throw Exception('Unexpected response format: Expected a list of emails.');
        }
      } else {
        throw Exception('Failed to fetch emails. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching emails: $e');
      return false;
    }
  }

  // Refactored loginUser function
  Future<void> loginUser(String email, String password) async {
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
        body: jsonEncode({'email': email, 'password': password}),
      );

      Navigator.pop(context); // Dismiss loader

      if (response.statusCode == 200) {
        // Handle successful login
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        // Save token in shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );

        // Navigate to the main app
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    final lightGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0b2a2f), Color(0xFF14444F)],
    );

    final darkGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF424242), Color(0xFF2C2C2C)],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: themeNotifier.isDarkTheme ? darkGradient : lightGradient,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 60.h,
              left: 40.w,
              right: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "MEDHIR",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5F5DC),
                      letterSpacing: 3.sp,
                      shadows: [
                        Shadow(
                          offset: Offset(3.w, 3.h),
                          blurRadius: 8.r,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        Shadow(
                          offset: Offset(-2.w, -2.h),
                          blurRadius: 6.r,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 160.h,
              left: 40.w,
              right: 40.w,
              child: GradientText(
                "RUN YOUR BUSINESS\nNOT THE HASSLE",
                gradient: LinearGradient(
                  colors: [
                    themeNotifier.isDarkTheme
                        ? Colors.grey[300]!
                        : Colors.grey[400]!,
                    themeNotifier.isDarkTheme
                        ? Colors.grey[500]!
                        : Colors.grey[300]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),



            Positioned(
              top: 250.h,
              left: 40.w,
              right: 40.w,
              child: Column(
                children: [
                  TextFieldDecoration(
                    controller: credController,
                    hintText: 'Email / Phone Number',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                  ),
                  SizedBox(height: 20.h),
                  if (emailExists)
                    TextFieldDecoration(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                    ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: 0.5.sw,
                    child: ElevatedButton(
                      onPressed: () async {
                        String email = credController.text.trim();
                        String password = passwordController.text.trim();

                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter an email")),
                          );
                          return;
                        }

                        if (!emailExists && password.isEmpty) {
                          bool emailExists = await isEmailAvailable(email);
                          setState(() {
                            this.emailExists = emailExists;
                          });

                          if (emailExists) {
                            setState(() {
                              isLoggingIn = true;
                            });
                          } else {
                            Navigator.pushNamed(context, '/signup', arguments: email);
                          }
                        } else if (emailExists && isLoggingIn) {
                          loginUser(email, password);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color.fromARGB(255, 204, 170, 0)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 50.h)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0.r),
                          ),
                        ),
                      ),
                      child: Text(
                        isLoggingIn ? 'Login' : 'Continue',
                        style: TextStyle(fontSize: 18.sp, color: Color(0xFF000000)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 450.h, // Adjusted position for the bottom row
              left: 40.w,
              right: 40.w,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1.5.h,
                          color: themeNotifier.isDarkTheme
                              ? Colors.grey[600]
                              : Colors.grey[300],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: themeNotifier.isDarkTheme
                                ? Colors.grey[300]
                                : Colors.grey[600],
                            letterSpacing: 1.5.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1.5.h,
                          color: themeNotifier.isDarkTheme
                              ? Colors.grey[600]
                              : Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  TextButtonWidget(
                    text: "Sign in with Google",
                    onPressed: () {
                      // Add Google login logic here
                    },
                    icon: Image.asset(
                      'assets/google_icon.png',
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextButtonWidget(
                    text: "Sign in with Facebook",
                    onPressed: () {
                      // Add Facebook login logic here
                    },
                    icon: Image.asset(
                      'assets/facebook_icon.png',
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextButtonWidget(
                    text: "Sign in with Instagram",
                    onPressed: () {
                      // Add Instagram login logic here
                    },
                    icon: Image.asset(
                      'assets/instagram_logo.png',
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// Custom Text Button widget
class TextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon;

  const TextButtonWidget({
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC0C0C0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          elevation: 4,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(width: 8.0),
            ],
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14.sp,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Gradient text widget
class GradientText extends StatelessWidget {
  const GradientText(this.text, {Key? key, required this.gradient})
      : super(key: key);

  final String text;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

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
