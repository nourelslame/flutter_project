import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================
  // تسجيل دخول
  // ============================================
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String uid = userCredential.user!.uid;

      // جلب بيانات المستخدم من Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        await _auth.signOut();
        return {
          'success': false,
          'message': 'حسابك غير مسجل في النظام'
        };
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // التحقق من موافقة الطالب
      if (userData['role'] == 'student' && userData['approved'] == false) {
        await _auth.signOut();
        return {
          'success': false,
          'message': 'حسابك قيد المراجعة من قبل الإدارة'
        };
      }

      return {
        'success': true,
        'role': userData['role'],
        'name': userData['name'],
        'uid': uid,
      };
    } on FirebaseAuthException catch (e) {
      String message = 'خطأ في تسجيل الدخول';
      if (e.code == 'user-not-found') {
        message = 'البريد الإلكتروني غير مسجل';
      } else if (e.code == 'wrong-password') {
        message = 'كلمة المرور خاطئة';
      } else if (e.code == 'invalid-email') {
        message = 'البريد الإلكتروني غير صحيح';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ============================================
  // تسجيل جديد
  // ============================================
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
    String role, {
    String? studentId,
  }) async {
    try {
      // إنشاء حساب في Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String uid = userCredential.user!.uid;

      // إذا كان طالب
      if (role == 'student') {
        if (studentId == null || studentId.isEmpty) {
          await userCredential.user!.delete();
          return {
            'success': false,
            'message': 'رقم التسجيل إجباري للطلاب'
          };
        }

        // إضافة في pendingStudents (انتظار موافقة Admin)
        await _firestore.collection('pendingStudents').doc(uid).set({
          'name': name.trim(),
          'email': email.trim(),
          'studentId': studentId.trim(),
          'requestedAt': FieldValue.serverTimestamp(),
        });

        await _auth.signOut();
        return {
          'success': true,
          'message': 'تم التسجيل! انتظر موافقة الإدارة',
          'role': 'student'
        };
      } else {
        // Admin أو Teacher - تسجيل مباشر
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': email.trim(),
          'name': name.trim(),
          'role': role,
          'approved': true,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return {
          'success': true,
          'message': 'تم التسجيل بنجاح!',
          'role': role,
          'uid': uid,
        };
      }
    } on FirebaseAuthException catch (e) {
      String message = 'فشل التسجيل';
      if (e.code == 'weak-password') {
        message = 'كلمة المرور ضعيفة جداً (6 أحرف على الأقل)';
      } else if (e.code == 'email-already-in-use') {
        message = 'البريد الإلكتروني مستخدم بالفعل';
      } else if (e.code == 'invalid-email') {
        message = 'البريد الإلكتروني غير صحيح';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ============================================
  // تسجيل خروج
  // ============================================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ============================================
  // الحصول على المستخدم الحالي
  // ============================================
  User? get currentUser => _auth.currentUser;

  // ============================================
  // جلب بيانات المستخدم الحالي
  // ============================================
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    if (currentUser == null) return null;

    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}
