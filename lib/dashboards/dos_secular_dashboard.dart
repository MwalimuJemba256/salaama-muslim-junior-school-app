import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
class DosSecularDashboard extends StatelessWidget {
  @override Widget build(BuildContext context) => Scaffold(appBar: buildAppBar(context, "D.O.S Secular"), body: GridView.count(crossAxisCount: 2, children: [
    _c("My Teachers", Icons.groups), _c("Timetable", Icons.calendar_month), _c("Exams Secular", Icons.quiz), _c("Lesson Plans", Icons.book), _c("Attendance", Icons.check),
  ]));
  Widget _c(String t, IconData i) => Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, color: Color(0xFF0B6CB3)), SizedBox(height:8), Text(t, style: TextStyle(fontSize:11))]));
}