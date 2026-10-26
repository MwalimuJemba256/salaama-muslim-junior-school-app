import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
class TeacherSecularDashboard extends StatelessWidget {
  @override Widget build(BuildContext context) => Scaffold(appBar: buildAppBar(context, "Teacher Secular"), body: GridView.count(crossAxisCount: 2, children: [
    _c("My Classes", Icons.class_), _c("Mark Attendance", Icons.fact_check), _c("Enter Marks", Icons.edit), _c("My Timetable", Icons.schedule), _c("Notices", Icons.campaign),
  ]));
  Widget _c(String t, IconData i) => Card(child: ListTile(leading: Icon(i, color: Color(0xFF0B6CB3)), title: Text(t, style: TextStyle(fontSize:11))));
}