import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF02020C),
                  Color(0xFF121D39),
                  Color(0xFF114C8F),
                ],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value * 2 * 3.14,
                  child: child,
                );
              },
              child: SvgPicture.asset(
                'assets/blob.svg',
                width: 300,
                height: 300,
                colorFilter: ColorFilter.mode(
                  Color(0xFF4A4E69).withValues(alpha: 0.3),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            child: SvgPicture.asset(
              'assets/blob2.svg',
              width: 400,
              height: 400,
              colorFilter: ColorFilter.mode(
                Color(0xFF4A4E69).withValues(alpha: 0.3),
                BlendMode.srcIn,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    SizedBox(height: 40),
                    _buildGlassmorphicContainer(
                      child: Column(
                        children: [
                          _buildTextField('Email', Icons.email),
                          SizedBox(height: 20),
                          _buildTextField('Password', Icons.lock, isPassword: true),
                          SizedBox(height: 30),
                          _buildLoginButton(),
                          SizedBox(height: 20),
                          _buildCreateAccountButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Icon(
          Icons.bug_report,
          size: 80,
          color: Color(0xFFE94560),
        ),
        SizedBox(height: 16),
        Text(
          'Red Weevil\nDetector',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Color(0xFFE94560),
            fontSize: 32,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Color(0xFFE94560).withValues(alpha: 0.3),
                offset: Offset(5.0, 5.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlassmorphicContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Color(0xFF9BA4B4)),
        prefixIcon: Icon(icon, color: Color(0xFF9BA4B4)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFF9BA4B4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFFE94560)),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/home');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Color(0xFFE94560),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        'Log in',
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Create an account',
        style: GoogleFonts.poppins(
          color: Color(0xFF9BA4B4),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

