import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cards = [
      {"t":"Staff Management","i":Icons.groups,"r":"/staff_management"},
      {"t":"Classes","i":Icons.class_,"r":"/classes"},
      {"t":"Attendance","i":Icons.fact_check,"r":"/attendance"},
      {"t":"Exams","i":Icons.quiz,"r":"/exams"},
      {"t":"Tahfiizu Quran","i":Icons.menu_book,"r":"/tahfiizu"},
      {"t":"Fees","i":Icons.receipt,"r":"/fees"},
      {"t":"Cashflow","i":Icons.account_balance,"r":"/cashflow"},
      {"t":"Chat","i":Icons.chat,"r":"/chat"},
      {"t":"Notices","i":Icons.campaign,"r":"/notices"},
      {"t":"Media","i":Icons.photo_library,"r":"/media"},
      {"t":"Settings","i":Icons.settings,"r":"/settings"},
      {"t":"Users","i":Icons.manage_accounts,"r":"/users"},
    ];
    return Scaffold(
      appBar: buildAppBar(context, "Admin Dashboard"),
      body: GridView.builder(padding: EdgeInsets.all(12), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.9), itemCount: cards.length, itemBuilder: (_,i) => Card(child: InkWell(onTap: (){ if(cards[i]['r']=='/staff_management') Navigator.pushNamed(context,'/staff_management'); }, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircleAvatar(backgroundColor: i%2==0?Color(0xFF0B6CB3):Color(0xFF8BC53F), child: Icon(cards[i]['i'] as IconData, color: Colors.white)), SizedBox(height:8), Text(cards[i]['t'] as String, textAlign:TextAlign.center, style: TextStyle(fontSize:11, fontWeight: FontWeight.bold))])))),
    );
  }
}