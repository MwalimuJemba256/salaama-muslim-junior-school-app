import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';
import '../../constants.dart';

class AdminStaffManagement extends StatefulWidget {
  @override
  _AdminStaffManagementState createState() => _AdminStaffManagementState();
}

class _AdminStaffManagementState extends State<AdminStaffManagement> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _service = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B6CB3), // Your logo blue
        title: Row(children: [
          Image.asset('assets/logo.png', height: 40), // YOUR EXACT LOGO
          SizedBox(width: 8),
          Text("Staff Management", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ]),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Color(0xFF8BC53F),
          unselectedLabelColor: Colors.white,
          tabs: [
            Tab(text: "SECULAR", icon: Icon(Icons.school)),
            Tab(text: "THEOLOGY", icon: Icon(Icons.menu_book)),
            Tab(text: "Tahfiizu", icon: Icon(Icons.auto_stories)),
            Tab(text: "OTHER", icon: Icon(Icons.work)),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () => showDialog(
            context: context, builder: (_) => AlertDialog(
              title: Row(children: [Image.asset('assets/logo.png', height: 30), Text(" Developer")]),
              content: Text("Developer: Jemba Abdul Hamiid\n0709157254 / 0785831666\nWefunira app ey'omulimu gwo, sacco yo, essomero n'endala"),
            ),
          )),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSecularTab(),
          _buildTheologyTab(),
          _buildTahfiizuTab(),
          _buildOtherTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF8BC53F),
        child: Icon(Icons.person_add),
        onPressed: () => _showAddUserDialog(),
      ),
    );
  }

  // ===== TAB 1 - SECULAR: English, Math, Science, SST + D.O.S Secular =====
  Widget _buildSecularTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _service.getStaffByTab('SECULAR'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        var docs = snapshot.data!.docs;
        return ListView(
          children: [
            _headerCard("SECULAR DEPARTMENT", "English, Mathematics, Science, SST + D.O.S Secular", Colors.blue),
            ...docs.map((doc) => _userTile(doc)).toList(),
          ],
        );
      },
    );
  }

  // ===== TAB 2 - THEOLOGY: Quran, Fiqh, Lugha, Tarbiah + D.O.S Theology =====
  Widget _buildTheologyTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _service.getStaffByTab('THEOLOGY'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        var docs = snapshot.data!.docs;
        return ListView(
          children: [
            _headerCard("THEOLOGY DEPARTMENT", "Quran, Fiqh, Lugha (Arabic), Tarbiah + D.O.S Theology", Colors.green),
            ...docs.map((doc) => _userTile(doc)).toList(),
          ],
        );
      },
    );
  }

  // ===== TAB 3 - Tahfiizu: Hifzu, Darsu Sitta, Omuraajia =====
  Widget _buildTahfiizuTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _service.getStaffByTab('Tahfiizu'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        var docs = snapshot.data!.docs;
        return ListView(
          children: [
            _headerCard("TAHFIIZU QURAN", "Hifzu (memorized), Darsu Sitta (last 6), Omuraajia (revision), Juz 1-30", Color(0xFF0B6CB3)),
            ...docs.map((doc) => _userTile(doc, isTahfiizu: true)).toList(),
          ],
        );
      },
    );
  }

  // ===== TAB 4 - OTHER: Cook, Guard, Cleaner, Driver, Matron, Secretary + Bursar =====
  Widget _buildOtherTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _service.getStaffByTab('OTHER'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        var docs = snapshot.data!.docs;
        return ListView(
          children: [
            _headerCard("OTHER STAFF + BURSAR", "Cook, Guard, Cleaner, Driver, Matron, Secretary, Bursar", Colors.orange),
            ...docs.map((doc) => _userTile(doc)).toList(),
          ],
        );
      },
    );
  }

  Widget _headerCard(String title, String subtitle, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Image.asset('assets/logo.png', height: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 10)),
      ),
    );
  }

  // ===== USER TILE - With All Actions =====
  Widget _userTile(DocumentSnapshot doc, {bool isTahfiizu = false}) {
    var data = doc.data() as Map<String, dynamic>;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF0B6CB3),
          child: Text(data['name'][0].toString().toUpperCase(), style: TextStyle(color: Colors.white)),
        ),
        title: Text(data['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("${data['role']} | ${data['subject'] ?? ''} | Class: ${data['classAssigned'] ?? ''}", style: TextStyle(fontSize: 10)),
          Text("Phone: ${data['phone']} | Salary: ${data['salary'] ?? 0}", style: TextStyle(fontSize: 10)),
          if (isTahfiizu) Text("Hifzu: ${data['hifzu'] ?? ''} | Darsu Sitta: ${data['darsuSitta'] ?? ''}", style: TextStyle(fontSize: 9, color: Colors.green)),
          Text("Status: ${data['approved'] == true ? 'Approved ✅' : 'Pending ⏳'}", style: TextStyle(fontSize: 9, color: data['approved'] == true ? Colors.green : Colors.red)),
        ]),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(children: [
              // Salary / Transport / Allowance - Admin completes
              Row(children: [
                Expanded(child: _infoChip("Salary", "UGX ${data['salary'] ?? 0}")),
                Expanded(child: _infoChip("Transport", "UGX ${data['transport'] ?? 0}")),
                Expanded(child: _infoChip("Allowance", "UGX ${data['allowance'] ?? 0}")),
              ]),
              SizedBox(height: 8),
              // ACTIONS: Edit, Delete, Block/Activate, Reset Password, View Login History
              Wrap(spacing: 6, children: [
                ElevatedButton.icon(icon: Icon(Icons.edit, size: 14), label: Text("Edit", style: TextStyle(fontSize: 10)), onPressed: () => _showEditDialog(doc), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B6CB3))),
                ElevatedButton.icon(icon: Icon(Icons.delete, size: 14), label: Text("Delete", style: TextStyle(fontSize: 10)), onPressed: () => _deleteUser(doc.id), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
                ElevatedButton.icon(icon: Icon(Icons.block, size: 14), label: Text(data['status'] == 'blocked' ? "Activate" : "Block", style: TextStyle(fontSize: 10)), onPressed: () => _toggleBlock(doc), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange)),
                ElevatedButton.icon(icon: Icon(Icons.lock_reset, size: 14), label: Text("Reset Pwd", style: TextStyle(fontSize: 10)), onPressed: () => _resetPassword(doc), style: ElevatedButton.styleFrom(backgroundColor: Colors.grey)),
                ElevatedButton.icon(icon: Icon(Icons.history, size: 14), label: Text("Login History", style: TextStyle(fontSize: 10)), onPressed: () => _showLoginHistory(doc), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8BC53F))),
              ]),
              SizedBox(height: 8),
              // Approve with Salary form
              if (data['approved'] == false)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8BC53F)),
                  child: Text("COMPLETE APPROVAL - Add Salary/Subject/Class & Send Message"),
                  onPressed: () => _showApprovalDialog(doc),
                ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Card(child: Padding(padding: EdgeInsets.all(6), child: Column(children: [Text(label, style: TextStyle(fontSize: 8)), Text(value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))])),);
  }

  // ===== DIALOGS =====
  void _showAddUserDialog() {
    // Add New User: Name, Phone, Role, Subject/Class Assigned
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Row(children: [Image.asset('assets/logo.png', height: 25), Text(" Add New User")]),
      content: SingleChildScrollView(child: Column(children: [
        TextField(decoration: InputDecoration(labelText: "Name")),
        TextField(decoration: InputDecoration(labelText: "Phone")),
        DropdownButtonFormField(items: ["Teacher secular","Teacher theology","Tahfiizu Sheikh","Cook","Guard","Cleaner","Driver","Matron","Secretary","Burser"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v){}, decoration: InputDecoration(labelText: "Role")),
        TextField(decoration: InputDecoration(labelText: "Subject / Class Assigned")),
      ])),
      actions: [TextButton(child: Text("Add"), onPressed: (){})],
    ));
  }

  void _showApprovalDialog(DocumentSnapshot doc) {
    var salaryCtrl = TextEditingController();
    var transportCtrl = TextEditingController();
    var allowanceCtrl = TextEditingController();
    var subjectCtrl = TextEditingController();
    var classCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Approve ${doc['name']} - بسم الله"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: salaryCtrl, decoration: InputDecoration(labelText: "Salary UGX"), keyboardType: TextInputType.number),
        TextField(controller: transportCtrl, decoration: InputDecoration(labelText: "Transport if any"), keyboardType: TextInputType.number),
        TextField(controller: allowanceCtrl, decoration: InputDecoration(labelText: "Allowance if any"), keyboardType: TextInputType.number),
        TextField(controller: subjectCtrl, decoration: InputDecoration(labelText: "Subject / Role Detail")),
        TextField(controller: classCtrl, decoration: InputDecoration(labelText: "Class Assigned (Nursery-P7)")),
      ]),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B6CB3)),
          child: Text("Approve & Send Message"),
          onPressed: () async {
            await FirestoreService().approveUser(
              userId: doc.id,
              salary: double.tryParse(salaryCtrl.text) ?? 0,
              transport: double.tryParse(transportCtrl.text) ?? 0,
              allowance: double.tryParse(allowanceCtrl.text) ?? 0,
              subject: subjectCtrl.text,
              classAssigned: classCtrl.text,
            );
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Approved & Message Sent to ${doc['name']}")));
          },
        ),
      ],
    ));
  }

  void _showEditDialog(DocumentSnapshot doc) {/* Edit User */}
  void _deleteUser(String id) async { await FirebaseFirestore.instance.collection('users').doc(id).delete(); }
  void _toggleBlock(DocumentSnapshot doc) async {
    String newStatus = doc['status'] == 'blocked' ? 'active' : 'blocked';
    await FirebaseFirestore.instance.collection('users').doc(doc.id).update({'status': newStatus});
  }
  void _resetPassword(DocumentSnapshot doc) async { /* Reset logic */ }
  void _showLoginHistory(DocumentSnapshot doc) {
    List history = doc['loginHistory'] ?? [];
    showDialog(context: context, builder: (_) => AlertDialog(title: Text("Login History - ${doc['name']}"), content: Text(history.join("\n"))));
  }
}