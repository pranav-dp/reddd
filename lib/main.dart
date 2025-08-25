import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'block_page.dart';
import 'device_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Red Weevil Detector',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFFFFD700),
        scaffoldBackgroundColor: Color(0xFF02020C),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFFE94560),
          surface: Color(0xFF121D39),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/blocks': (context) => BlockPage(),
        '/devices': (context) => DevicePage(),
      },
    );
  }
}

