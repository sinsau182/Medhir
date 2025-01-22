import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medhir/ThemeNotifier.dart';
import 'package:medhir/Screens/Home.dart';
import 'package:medhir/Screens/Login.dart';
import 'package:medhir/Screens/SignUp.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812), // Design size for responsiveness
      builder: (context, child) => ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: MyApp(),
      ),
    ),
  );
}

// Define your app's color constants
class AppColors {
  static const Color primary = Color(0xFF42A5F5); // Consistent blue
  static const Color accent = Color(0xFFEF5350); // Consistent red
  static const Color background = Color(0xFFF5F5F5); // Light background
  static const Color darkBackground = Color(0xFF121212); // Dark background
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the ThemeNotifier
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Medhir App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
      ),
      themeMode: themeNotifier.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.white.withOpacity(0.95), // Apply a subtle global color adjustment
          BlendMode.modulate,
        ),
        child: HomePage(),
      ),
      routes: {
        '/login': (context) => LoginPage(),  // Replace with your Login page
        '/signup': (context) => SignUpScreen(), // Replace with your Signup page
      },
    );

  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(), // Display the HomeScreen
    );
  }
}
