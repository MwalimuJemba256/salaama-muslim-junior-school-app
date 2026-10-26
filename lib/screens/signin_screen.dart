import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool isSignUp = true; // First time = Sign Up, Second = Sign In
  bool loading = false;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B6CB3),
        title: Row(children: [
          Image.asset('assets/logo.png', height: 35), // YOUR EXACT LOGO
          SizedBox(width: 8),
          Text("SALAAMA SCHOOL", style: TextStyle(fontSize: 14)),
        ]),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
            content: Text("Developer: Jemba Abdul Hamiid\n0709157254 / 0785831666\nWefunira app ey'omulimu gwo, sacco yo, essomero n'endala"),
          ))),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text("بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ", style: TextStyle(fontSize: 20, color: Color(0xFFB8860B))),
            SizedBox(height: 15),
            Image.asset('assets/logo.png', height: 120), // YOUR EXACT LOGO
            SizedBox(height: 15),
            Text(isSignUp ? "First Time Registration" : "Welcome Back - Sign In", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B6CB3))),
            SizedBox(height: 20),

            // Name, Email, Phone - First time only
            if (isSignUp) ...[
              TextField(controller: _nameCtrl, decoration: InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
              SizedBox(height: 12),
              TextField(controller: _phoneCtrl, decoration: InputDecoration(labelText: "Phone Number (07...)", prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()), keyboardType: TextInputType.phone),
              SizedBox(height: 12),
            ],
            TextField(controller: _emailCtrl, decoration: InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email), border: OutlineInputBorder())),
            SizedBox(height: 12),
            TextField(controller: _passCtrl, decoration: InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock), border: OutlineInputBorder()), obscureText: true),
            SizedBox(height: 20),

            loading ? CircularProgressIndicator() :
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B6CB3), minimumSize: Size(double.infinity, 50)),
              child: Text(isSignUp ? "Register & Continue" : "Sign In", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                setState(() => loading = true);
                try {
                  if (isSignUp) {
                    await _auth.signUpFirstTime(name: _nameCtrl.text, email: _emailCtrl.text, phone: _phoneCtrl.text, password: _passCtrl.text);
                    Navigator.pushReplacementNamed(context, '/category_select');
                  } else {
                    var userDoc = await _auth.signIn(email: _emailCtrl.text, password: _passCtrl.text);
                    String route = _auth.getDashboardRoute(userDoc['role']);
                    Navigator.pushReplacementNamed(context, route);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
                setState(() => loading = false);
              },
            ),
            SizedBox(height: 10),
            TextButton(
              child: Text(isSignUp ? "Already have account? Sign In" : "First time? Register"),
              onPressed: () => setState(() => isSignUp = !isSignUp),
            ),
          ],
        ),
      ),
    );
  }
}