import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medhir/Screens/Login.dart';
import 'package:medhir/Screens/SignUp.dart';
import 'package:medhir/ThemeNotifier.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomeScreen extends StatelessWidget {
  final TextEditingController credController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    // Background gradients remain unchanged
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
            // Header with brand name (unchanged)
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

            // Tagline text
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
              bottom: 200.h, // Adjusted to position above the "OR" line
              left: 40.w,
              right: 40.w,
              child: Column(
                children: [
                  // Input field for mobile number or email address
                  TextFieldDecoration(
                    controller: credController,
                    hintText: 'Email / Phone Number',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                  ),
                  SizedBox(height: 20.h),

                  // Continue button
                  SizedBox(
                    width: 0.5.sw, // Button width as 50% of screen width
                    child: ElevatedButton(
                      onPressed: () {

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
                          Text('Continue', style: TextStyle(fontSize: 18.sp, color: Color(0xFF000000))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Optimized "or" line component
            Positioned(
              top: 420.h, // Adjusted to fit the layout
              left: 40.w,
              right: 40.w,
              child: Row(
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
            ),

            // Four login option buttons
            Positioned(
              top: 250.h,
              left: 40.w,
              right: 40.w,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  TextButtonWidget(
                    text: "Sign in with Google",
                    onPressed: () {
                      // Add Google login logic here
                    },
                    icon: Image.asset(
                      'assets/google_icon.png', // Your custom icon path
                      height: 30.0, // Adjust the size of the icon
                      width: 30.0,
                    ),
                  ),


                  SizedBox(height: 20.h),
                  TextButtonWidget(
                    text: "Sign in with Facebook",
                    onPressed: () {
                      // Add Google login logic here
                    },
                    icon: Image.asset(
                      'assets/facebook_icon.png', // Your custom icon path
                      height: 30.0, // Adjust the size of the icon
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
  final Widget? icon; // Widget type for more flexibility (can be any widget, e.g., Image or Icon)

  const TextButtonWidget({
    required this.text,
    required this.onPressed,
    this.icon, // Allow any widget as the icon
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
          mainAxisSize: MainAxisSize.min, // Wrap the content
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!, // Display the customized icon if provided
              SizedBox(width: 8.0), // Space between icon and text
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