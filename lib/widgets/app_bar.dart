import 'package:flutter/material.dart';
AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Color(0xFF0B6CB3),
    title: Row(children: [Image.asset('assets/logo.png', height: 38), SizedBox(width:8), Expanded(child: Text(title, style: TextStyle(fontSize:13)))]),
    actions: [PopupMenuButton(itemBuilder: (_) => [PopupMenuItem(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children:[Image.asset('assets/logo.png', height:25), Text(" Developer")]), Text("Jemba Abdul Hamiid", style: TextStyle(fontWeight: FontWeight.bold)), Text("0709157254 / 0785831666"), Text("Wefunira app ey'omulimu gwo", style: TextStyle(fontSize:10)), Text("sacco yo, essomero n'endala", style: TextStyle(fontSize:10))]))], icon: Icon(Icons.more_vert))],
  );
}