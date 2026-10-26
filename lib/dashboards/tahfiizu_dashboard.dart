import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
class TahfiizuDashboard extends StatelessWidget {
  @override Widget build(BuildContext context) => Scaffold(appBar: buildAppBar(context, "Tahfiizu Sheikh - Juz 1-30"), body: GridView.count(crossAxisCount: 2, children: [
    _c("Students Juz", Icons.format_list_numbered, "1-30 Tracking"),
    _c("Hifzu", Icons.auto_stories, "Memorized"),
    _c("Darsu Sitta & Omuraajia", Icons.replay, "Last 6 & Revision"),
    _c("Issue Certificate ممتاز", Icons.workspace_premium, "Arabic PDF + Share"),
  ]));
  Widget _c(String t, IconData i, String sub) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: Color(0xFF0B6CB3), child: Icon(i, color: Colors.white, size:18)), title: Text(t, style: TextStyle(fontSize:11, fontWeight: FontWeight.bold)), subtitle: Text(sub, style: TextStyle(fontSize:8))));
}