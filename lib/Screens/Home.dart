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

    // Updated gradients for light and dark themes
    final lightGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0A1128), // Dark navy blue
        Color(0xFF1B263B), // Lighter navy blue
        Color(0xFFEAEAEA), // Subtle off-white
      ],
    );

    final darkGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF1B263B), // Dark blue
        Color(0xFF0A1128), // Dark navy blue
      ],
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeNotifier.isDarkTheme ? darkGradient : lightGradient,
        ),
        child: Stack(
          children: [
            // Header with brand name and theme toggle button, moved upwards
            Positioned(
              top: screenHeight * 0.05, // Adjusted position upwards
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "MEDHIR",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3.0,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      themeNotifier.isDarkTheme
                          ? Icons.wb_sunny
                          : Icons.nightlight_round,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      themeNotifier.toggleTheme();
                    },
                  ),
                ],
              ),
            ),

            // Updated Tagline text, moved upwards
            Positioned(
              top: screenHeight * 0.18, // Adjusted position upwards
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: Text(
                "RUN YOUR BUSINESS\nNOT THE HASSLE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins', // Keeping the original font (Poppins)
                  fontSize: 36, // Adjust the font size for readability
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set the font color to white
                  shadows: [
                    Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 8.0,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),

            // Illustration, moved upwards
            Positioned(
              top: screenHeight * 0.26, // Adjusted position upwards
              left: screenWidth * 0.10,
              right: screenWidth * 0.10,
              child: Image.asset(
                'assets/rocket.png', // Replace with your image path
                height: screenHeight * 0.40,
                fit: BoxFit.contain,
              ),
            ),

            // Buttons, moved upwards
            Positioned(
              bottom: screenHeight * 0.13, // Adjusted position upwards
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
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1B263B), // Blue color (used in gradient)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          padding: EdgeInsets.symmetric(vertical: 15),
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
