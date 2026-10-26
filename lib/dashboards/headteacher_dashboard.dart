import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
class HeadteacherDashboard extends StatelessWidget {
  @override Widget build(BuildContext context){
    final cards = ["Staff Management","Classes","Attendance","Exams","Tahfiizu","Chat","Notices","Media","Timetable","Settings"];
    return Scaffold(appBar: buildAppBar(context, "Headteacher"), body: GridView.count(crossAxisCount: 3, children: cards.map((t) => Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.school, color: Color(0xFF0B6CB3)), Text(t, style: TextStyle(fontSize:10), textAlign: TextAlign.center)]))).toList()));
  }
}