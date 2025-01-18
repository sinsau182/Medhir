import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medhir/Screens/Login.dart';
import 'package:medhir/Screens/SignUp.dart';
import 'package:medhir/ThemeNotifier.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    // Define gradients for light and dark themes
    final lightGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0b2a2f),
        Color(0xFF14444F),
      ],
    );

    final darkGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF424242),
        Color(0xFF2C2C2C),
      ],
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeNotifier.isDarkTheme ? darkGradient : lightGradient,
        ),
        child: Stack(
          children: [
            // Header with brand name
            Positioned(
              top: 60.h, // Adjusted for screen height
              left: 40.w, // Adjusted for screen width
              right: 40.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "MEDHIR",
                    style: TextStyle(
                      fontSize: 26.sp, // Responsive font size
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

            // Tagline text
            Positioned(
              top: 200.h,
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

            // Illustration
            Positioned(
              top: 260.h,
              left: 40.w,
              right: 40.w,
              child: Image.asset(
                'assets/rocket.png',
                height: 300.h, // Adjusted for screen height
                fit: BoxFit.contain,
              ),
            ),

            // Buttons
            Positioned(
              bottom: 100.h,
              left: 40.w,
              right: 40.w,
              child: Column(
                children: [
                  TextButtonWidget(
                    text: "Login",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  TextButtonWidget(
                    text: "Sign Up",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
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

  const TextButtonWidget({
    required this.text,
    required this.onPressed,
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
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16.sp,
            color: Colors.grey[800],
          ),
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
