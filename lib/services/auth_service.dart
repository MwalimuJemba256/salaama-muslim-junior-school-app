import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Current User
  User? get currentUser => _auth.currentUser;

  // FIRST TIME SIGN UP - Name, Email, Phone
  Future<UserCredential> signUpFirstTime({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Save basic info, waiting for category selection
      await _db.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'role': 'pending', // Not selected yet
        'approved': false,
        'salary': 0,
        'transport': 0,
        'allowance': 0,
        'subject': '',
        'classAssigned': '',
        'status': 'pending_approval',
        'photoUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
        'loginHistory': [FieldValue.serverTimestamp()],
      });

      return cred;
    } catch (e) {
      rethrow;
    }
  }

  // SECOND STEP - Select Category (10 categories)
  Future<void> selectCategory({required String category}) async {
    String role = category.toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('.', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '_');
    
    // Normalize roles
    if (role.contains('burser')) role = 'burser';
    if (role.contains('dos_secular')) role = 'dos_secular';
    if (role.contains('dos_theology')) role = 'dos_theology';
    if (role.contains('teacher_secular')) role = 'teacher_secular';
    if (role.contains('teacher_theology')) role = 'teacher_theology';
    if (role.contains('tahfiizu')) role = 'tahfiizu_sheikh';
    if (role.contains('other')) role = 'other';
    
    String uid = _auth.currentUser!.uid;
    await _db.collection('users').doc(uid).update({
      'role': role,
      'categorySelected': category,
      'categorySelectedAt': FieldValue.serverTimestamp(),
    });

    // If parent with same phone has child, link it
    if (role == 'parent') {
      var userDoc = await _db.collection('users').doc(uid).get();
      String phone = userDoc['phone'];
      var linkDoc = await _db.collection('parent_links').doc(phone).get();
      if (linkDoc.exists) {
        List studentIds = linkDoc['studentIds'];
        for (String sid in studentIds) {
          await _db.collection('students').doc(sid).update({'parentId': uid});
        }
      }
    }
  }

  // SIGN IN - Second time auto goes to category dashboard
  Future<DocumentSnapshot> signIn({
    required String email,
    required String password,
  }) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    
    // Update login history
    await _db.collection('users').doc(cred.user!.uid).update({
      'loginHistory': FieldValue.arrayUnion([FieldValue.serverTimestamp()]),
      'lastLogin': FieldValue.serverTimestamp(),
    });

    // Return user doc to check role
    var userDoc = await _db.collection('users').doc(cred.user!.uid).get();
    return userDoc;
  }

  // Get Dashboard by Role
  String getDashboardRoute(String role) {
    switch (role) {
      case 'admin': return '/admin_dashboard';
      case 'headteacher': return '/headteacher_dashboard';
      case 'burser': return '/bursar_dashboard';
      case 'dos_secular': return '/dos_secular_dashboard';
      case 'dos_theology': return '/dos_theology_dashboard';
      case 'teacher_secular': return '/teacher_secular_dashboard';
      case 'teacher_theology': return '/teacher_theology_dashboard';
      case 'tahfiizu_sheikh': return '/tahfiizu_dashboard';
      case 'other': return '/other_dashboard';
      case 'parent': return '/parent_dashboard';
      default: return '/category_select';
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // RESET PASSWORD
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // BLOCK / ACTIVATE USER - Admin only
  Future<void> toggleUserStatus(String userId, bool active) async {
    await _db.collection('users').doc(userId).update({
      'status': active ? 'active' : 'blocked',
    });
  }
}