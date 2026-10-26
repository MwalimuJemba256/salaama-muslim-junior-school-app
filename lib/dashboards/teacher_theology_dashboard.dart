import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
class TeacherTheologyDashboard extends StatelessWidget {
  @override Widget build(BuildContext context) => Scaffold(appBar: buildAppBar(context, "Teacher Theology"), body: GridView.count(crossAxisCount: 2, children: [
    _c("My Classes", Icons.class_), _c("Quran Attendance", Icons.mosque), _c("Theology Marks", Icons.quiz), _c("Tahfiizu Progress", Icons.book),
  ]));
  Widget _c(String t, IconData i) => Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, color: Color(0xFF0B6CB3)), Text(t, style: TextStyle(fontSize:11), textAlign: TextAlign.center)]));
}