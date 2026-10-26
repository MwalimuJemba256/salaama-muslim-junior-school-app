import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
class OtherStaffDashboard extends StatelessWidget {
  @override Widget build(BuildContext context) => Scaffold(appBar: buildAppBar(context, "Other Staff"), body: GridView.count(crossAxisCount: 2, children: [
    Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.fact_check, size:40, color: Color(0xFF0B6CB3)), Text("My Attendance"), Text("View Only", style: TextStyle(fontSize:9))])),
    Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.campaign, size:40, color: Color(0xFF8BC53F)), Text("Notices"), Text("School Notices", style: TextStyle(fontSize:9))])),
  ]));
}