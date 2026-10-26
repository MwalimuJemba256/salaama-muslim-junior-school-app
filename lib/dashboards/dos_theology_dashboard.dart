import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
class DosTheologyDashboard extends StatelessWidget {
  @override Widget build(BuildContext context) => Scaffold(appBar: buildAppBar(context, "D.O.S Theology"), body: GridView.count(crossAxisCount: 3, children: [
    _c("My Teachers", Icons.groups), _c("Quran", Icons.menu_book), _c("Fiqh", Icons.auto_stories), _c("Lugha", Icons.language), _c("Tarbiah", Icons.self_improvement), _c("Exams Theology", Icons.quiz), _c("Tahfiizu", Icons.mosque),
  ]));
  Widget _c(String t, IconData i) => Card(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, color: Colors.teal), Text(t, style: TextStyle(fontSize:10), textAlign: TextAlign.center)]));
}