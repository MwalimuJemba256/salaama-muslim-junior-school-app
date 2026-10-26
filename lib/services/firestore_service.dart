import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // COLLECTIONS
  CollectionReference get users => _db.collection('users');
  CollectionReference get students => _db.collection('students');
  CollectionReference get classes => _db.collection('classes');
  CollectionReference get attendance => _db.collection('attendance');
  CollectionReference get examsSecular => _db.collection('exams_secular');
  CollectionReference get examsTheology => _db.collection('exams_theology');
  CollectionReference get tahfiizu => _db.collection('tahfiizu');
  CollectionReference get fees => _db.collection('fees');
  CollectionReference get cashflow => _db.collection('cashflow');
  CollectionReference get notices => _db.collection('notices');
  CollectionReference get media => _db.collection('media');
  CollectionReference get chats => _db.collection('chats');
  CollectionReference get timetables => _db.collection('timetables');

  // ===== USERS =====
  Future<DocumentSnapshot> getCurrentUser() async {
    String uid = _auth.currentUser!.uid;
    return await users.doc(uid).get();
  }

  Future<String> getCurrentUserRole() async {
    var doc = await getCurrentUser();
    return doc['role'];
  }

  // Admin creates user with Salary/Transport/Allowance
  Future<void> approveUser({
    required String userId,
    required double salary,
    required double transport,
    required double allowance,
    required String subject,
    required String classAssigned,
  }) async {
    await users.doc(userId).update({
      'salary': salary,
      'transport': transport,
      'allowance': allowance,
      'subject': subject,
      'classAssigned': classAssigned,
      'approved': true,
      'approvedBy': _auth.currentUser!.uid,
      'approvedAt': FieldValue.serverTimestamp(),
    });

    // Send notification message to user
    await chats.add({
      'to': userId,
      'from': 'admin',
      'message': 'بسم الله - You have been approved by Admin. Salary: UGX $salary, Transport: $transport, Subject: $subject, Class: $classAssigned. Welcome to Salaama Muslim Junior School - DESTINED TO SUCCEED',
      'type': 'approval',
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });
  }

  // 4 TABS for Admin Staff Management
  Stream<QuerySnapshot> getStaffByTab(String tab) {
    if (tab == 'SECULAR') {
      return users.where('role', whereIn: ['teacher_secular', 'dos_secular']).snapshots();
    } else if (tab == 'THEOLOGY') {
      return users.where('role', whereIn: ['teacher_theology', 'dos_theology']).snapshots();
    } else if (tab == 'Tahfiizu') {
      return users.where('role', isEqualTo: 'tahfiizu_sheikh').snapshots();
    } else { // OTHER
      return users.where('role', whereIn: ['other', 'burser']).snapshots();
    }
  }

  // ===== STUDENTS - Nursery to P7 (10 Classes) =====
  List<String> classesList = [
    'Baby Class', 'Middle Class', 'Top Class',
    'P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7'
  ];

  Future<void> addStudent({
    required String name,
    required String className,
    required String parentPhone,
    required String stream,
  }) async {
    var studentRef = await students.add({
      'name': name,
      'class': className,
      'stream': stream,
      'parentPhone': parentPhone,
      'parentId': null, // Will be linked when parent signs up with same phone
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': _auth.currentUser!.uid,
    });

    // Auto-link Parent account if exists with same phone
    var parentQuery = await users.where('phone', isEqualTo: parentPhone).where('role', isEqualTo: 'parent').get();
    if (parentQuery.docs.isEmpty) {
      // Create parent account placeholder
      await _db.collection('parent_links').doc(parentPhone).set({
        'studentIds': FieldValue.arrayUnion([studentRef.id]),
      });
    }
  }

  // ===== ATTENDANCE - Daily =====
  Future<void> markAttendance({
    required String className,
    required String studentId,
    required String status, // present/absent/late
  }) async {
    String today = DateTime.now().toIso8601String().split('T')[0];
    await attendance.doc('${today}_$studentId').set({
      'studentId': studentId,
      'class': className,
      'date': today,
      'status': status,
      'markedBy': _auth.currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ===== FEES + CASHFLOW - Bursar & Admin only =====
  Future<void> collectFees({
    required String studentId,
    required double amount,
    required String term,
  }) async {
    String receiptNo = 'REC${DateTime.now().millisecondsSinceEpoch}';
    await fees.add({
      'studentId': studentId,
      'amount': amount,
      'receiptNo': receiptNo,
      'term': term,
      'collectedBy': _auth.currentUser!.uid,
      'date': FieldValue.serverTimestamp(),
    });

    // Add to cashflow Income
    await cashflow.add({
      'type': 'income',
      'category': 'fees',
      'amount': amount,
      'description': 'Fees from $studentId - $receiptNo',
      'receiptNo': receiptNo,
      'createdBy': _auth.currentUser!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addExpense({required double amount, required String desc}) async {
    await cashflow.add({
      'type': 'expense',
      'amount': amount,
      'description': desc,
      'createdBy': _auth.currentUser!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ===== TAHFIIZU - Juz 1-30 =====
  Future<void> updateTahfiizu({
    required String studentId,
    required int juzCompleted,
    required String hifzu,
    required String darsuSitta,
    required String omuraajia,
    required String level, // ممتاز, جيد جدا etc
  }) async {
    await tahfiizu.doc(studentId).set({
      'studentId': studentId,
      'juzCompleted': juzCompleted, // 1-30
      'hifzu': hifzu,
      'darsuSitta': darsuSitta,
      'omuraajia': omuraajia,
      'level': level,
      'updatedBy': _auth.currentUser!.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ===== CHAT - Role based =====
  Stream<QuerySnapshot> getChatsForCurrentUser() {
    return chats.where('to', isEqualTo: _auth.currentUser!.uid).orderBy('createdAt', descending: true).snapshots();
  }

  // ===== SETTINGS - Custom Subjects =====
  Future<void> addCustomSubject({required String name, required String type}) async {
    await _db.collection('settings').doc('subjects').set({
      'custom': FieldValue.arrayUnion([{'name': name, 'type': type}])
    }, SetOptions(merge: true));
  }
}