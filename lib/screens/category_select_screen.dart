import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class CategorySelectScreen extends StatefulWidget {
  @override
  _CategorySelectScreenState createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState extends State<CategorySelectScreen> {
  String? selectedCategory;
  bool loading = false;

  final List<Map<String, dynamic>> categories = [
    {"name": "Admin", "icon": Icons.admin_panel_settings, "color": Color(0xFF0B6CB3), "desc": "Super Administrator - Full Access"},
    {"name": "Headteacher", "icon": Icons.school, "color": Color(0xFF0A4A7A), "desc": "School Head - 10 Cards"},
    {"name": "Burser", "icon": Icons.account_balance_wallet, "color": Colors.green, "desc": "Finance - Fees & Cashflow"},
    {"name": "D.O.S secular", "icon": Icons.menu_book, "color": Colors.blue, "desc": "Director Secular - English, Math, Science, SST"},
    {"name": "D.O.S theology", "icon": Icons.auto_stories, "color": Colors.teal, "desc": "Director Theology - Quran, Fiqh, Lugha, Tarbiah"},
    {"name": "Teacher secular", "icon": Icons.person, "color": Colors.lightBlue, "desc": "Teacher Secular - My Classes"},
    {"name": "Teacher theology", "icon": Icons.person_2, "color": Colors.green, "desc": "Teacher Theology - Quran, Fiqh"},
    {"name": "Tahfiizu Sheikh", "icon": Icons.mosque, "color": Color(0xFF0B6CB3), "desc": "Quran Memorization - Juz 1-30"},
    {"name": "Other (non-teaching)", "icon": Icons.work, "color": Colors.orange, "desc": "Cook, Guard, Cleaner, Driver, Matron, Secretary"},
    {"name": "Parent", "icon": Icons.family_restroom, "color": Color(0xFF8BC53F), "desc": "Parent - View Own Child Only"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B6CB3),
        title: Row(children: [
          Image.asset('assets/logo.png', height: 35),
          SizedBox(width: 8),
          Text("Select Category", style: TextStyle(fontSize: 14)),
        ]),
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFF0B6CB3).withOpacity(0.1),
            padding: EdgeInsets.all(12),
            child: Row(children: [
              Image.asset('assets/logo.png', height: 30),
              SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("بسم الله - Choose your role at Salaama", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text("This will be saved automatically. Second time you open app, it takes you directly to this category.", style: TextStyle(fontSize: 10)),
              ])),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, i) {
                var cat = categories[i];
                bool isSelected = selectedCategory == cat['name'];
                return Card(
                  color: isSelected ? Color(0xFF8BC53F).withOpacity(0.2) : Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: cat['color'], child: Icon(cat['icon'], color: Colors.white, size: 20)),
                    title: Text(cat['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(cat['desc'], style: TextStyle(fontSize: 10)),
                    trailing: isSelected ? Icon(Icons.check_circle, color: Color(0xFF8BC53F)) : Icon(Icons.circle_outlined),
                    onTap: () => setState(() => selectedCategory = cat['name']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: loading ? CircularProgressIndicator() :
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B6CB3), minimumSize: Size(double.infinity, 50)),
              child: Text("Confirm & Go to Dashboard", style: TextStyle(color: Colors.white)),
              onPressed: selectedCategory == null ? null : () async {
                setState(() => loading = true);
                try {
                  await AuthService().selectCategory(category: selectedCategory!);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Category $selectedCategory saved! Waiting for Admin approval.")));
                  // Go to pending screen or dashboard
                  String role = selectedCategory!.toLowerCase().replaceAll(' ', '_').replaceAll('.', '').replaceAll('(', '').replaceAll(')', '').replaceAll('-', '_');
                  if (role.contains('burser')) role = 'burser';
                  if (role.contains('other')) role = 'other';
                  String route = AuthService().getDashboardRoute(role);
                  Navigator.pushReplacementNamed(context, route);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
                setState(() => loading = false);
              },
            ),
          ),
        ],
      ),
    );
  }
}