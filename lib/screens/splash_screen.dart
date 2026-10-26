import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // 2-3 sec loading then check auth
    Timer(Duration(seconds: 3), () async {
      await _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // First time - go to Sign In
      Navigator.pushReplacementNamed(context, '/signin');
    } else {
      // Second time - auto go to his category dashboard
      var doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!doc.exists || doc['role'] == 'pending' || doc['role'] == null) {
        Navigator.pushReplacementNamed(context, '/category_select');
      } else {
        String role = doc['role'];
        String route = AuthService().getDashboardRoute(role);
        Navigator.pushReplacementNamed(context, route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE3F2FD)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // بسم الله الرحمن الرحيم
                Text(
                  "بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFB8860B), fontFamily: 'Amiri'),
                ),
                SizedBox(height: 30),
                // YOUR EXACT LOGO - No change
                ScaleTransition(
                  scale: _animation,
                  child: Image.asset('assets/logo.png', width: 280, height: 280),
                ),
                SizedBox(height: 20),
                // Loading dots with logo colors
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(Color(0xFF0B6CB3)), SizedBox(width: 8),
                    _dot(Color(0xFF8BC53F)), SizedBox(width: 8),
                    _dot(Color(0xFF0B6CB3)),
                  ],
                ),
                SizedBox(height: 20),
                Text("DESTINED TO SUCCEED", style: TextStyle(letterSpacing: 2, color: Color(0xFF0B6CB3), fontWeight: FontWeight.bold)),
                SizedBox(height: 40),
                CircularProgressIndicator(color: Color(0xFF0B6CB3), strokeWidth: 2),
                SizedBox(height: 10),
                Text("Loading...", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color) => Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  @override void dispose() { _controller.dispose(); super.dispose(); }
}