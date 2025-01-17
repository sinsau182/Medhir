import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medhir/Screens/Login.dart';
import 'package:medhir/Screens/SignUp.dart';
import 'package:medhir/ThemeNotifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Define gradients for light and dark themes
    final lightGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0b2a2f), // Light theme top color
        Color(0xFF14444F), // Light theme bottom color
      ],
    );

    final darkGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF424242), // Lighter gray top color
        Color(0xFF2C2C2C), // Slightly lighter gray bottom color
      ],
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeNotifier.isDarkTheme ? darkGradient : lightGradient,
        ),
        child: Stack(
          children: [
            // Header with brand name and theme toggle button
            Positioned(
              top: screenHeight * 0.08,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "MEDHIR",
                    style: TextStyle(
                      fontSize: 26.0, // Large font size for boldness
                      fontWeight: FontWeight.bold, // Heavy weight for authenticity
                      color: Color(0xFFF5F5DC), // Off-white text color (Beige tone)
                      letterSpacing: 3.0, // Adds space for a premium feel
                      shadows: [
                        Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 8.0,
                          color: Colors.black.withOpacity(0.6), // Subtle shadow
                        ),
                        Shadow(
                          offset: Offset(-2.0, -2.0),
                          blurRadius: 6.0,
                          color: Colors.white.withOpacity(0.2), // Highlight effect
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            // Tagline text
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
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

            // Illustration (Updated with the new image)
            Positioned(
              top: screenHeight * 0.32,
              left: screenWidth * 0.10,
              right: screenWidth * 0.10,
              child: Image.asset(
                'assets/rocket.png', // Replace with your uploaded image path
                height: screenHeight * 0.40,
                fit: BoxFit.contain,
              ),
            ),

            // Buttons
            Positioned(
              bottom: screenHeight * 0.1,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: Column(
                children: [
                  // Login Button
                  TextButtonWidget(
                    text: "Login",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Sign Up Button
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
      height: 50, // Button height
      width: double.infinity, // Stretch to full width
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC0C0C0), // Light background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Smooth rounded corners
          ),
          elevation: 4, // Subtle shadow for depth
          padding: EdgeInsets.symmetric(horizontal: 20), // Padding inside the button
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center, // Center the text
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            color: Colors.grey[800], // Text color
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
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
