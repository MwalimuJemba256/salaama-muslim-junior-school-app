import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
class ParentDashboard extends StatelessWidget {
  @override Widget build(BuildContext context) => Scaffold(appBar: buildAppBar(context, "Parent - My Child"), body: GridView.count(crossAxisCount: 2, children: [
    _c("My Child Attendance", Icons.fact_check, "Daily"),
    _c("Fees Receipt", Icons.receipt, "Download EN/AR PDF + Share"),
    _c("Report Card", Icons.assessment, "EN/AR PDF"),
    _c("Tahfiizu Progress", Icons.mosque, "Juz 1-30"),
    _c("Notices", Icons.campaign, "School Notices"),
  ]));
  Widget _c(String t, IconData i, String sub) => Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(child: Icon(i)), SizedBox(height:6), Text(t, style: TextStyle(fontSize:10, fontWeight: FontWeight.bold), textAlign: TextAlign.center), Text(sub, style: TextStyle(fontSize:8))]));
}