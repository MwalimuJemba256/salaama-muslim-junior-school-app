import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BursarDashboard extends StatelessWidget {
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: buildAppBar(context, "Burser - Finance"),
      body: Column(children: [
        StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('cashflow').snapshots(), builder: (_,s){
          double inc=0, exp=0;
          if(s.hasData) for(var d in s.data!.docs){ if(d['type']=='income') inc+=d['amount']; else exp+=d['amount']; }
          return Card(color: Color(0xFF0B6CB3), margin: EdgeInsets.all(12), child: ListTile(title: Text("Balance: UGX ${inc-exp}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), subtitle: Text("Income: $inc | Expense: $exp", style: TextStyle(color: Color(0xFF8BC53F)))));
        }),
        Expanded(child: GridView.count(crossAxisCount: 2, children: [
          _card(context, "Fees Collection", Icons.receipt_long, "EN/AR PDF + Share"),
          _card(context, "Cashflow", Icons.wallet, "Add Expense/Income"),
          _card(context, "Students Paid/Unpaid", Icons.people, "10 Classes"),
          _card(context, "Reports", Icons.assessment, "Daily/Monthly PDF"),
        ])),
      ]),
    );
  }
  Widget _card(BuildContext c, String t, IconData i, String sub) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: Color(0xFF8BC53F), child: Icon(i, color: Colors.white)), title: Text(t, style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)), subtitle: Text(sub, style: TextStyle(fontSize:9))));
}