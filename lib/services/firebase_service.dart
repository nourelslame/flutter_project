import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================
  // Login
  // ============================================
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String uid = userCredential.user!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        await _auth.signOut();
        return {
          'success': false,
          'message': 'Your account is not registered in the system'
        };
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Check student approval
      if (userData['role'] == 'student' && userData['approved'] == false) {
        await _auth.signOut();
        return {
          'success': false,
          'message': 'Your account is under review by administration'
        };
      }

      return {
        'success': true,
        'role': userData['role'],
        'name': userData['name'],
        'uid': uid,
      };
    } on FirebaseAuthException catch (e) {
      String message = 'Login error';
      if (e.code == 'user-not-found') {
        message = 'Email not registered';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ============================================
  // Register
  // ============================================
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
    String role, {
    String? studentId,
  }) async {
    try {
      // Create account in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String uid = userCredential.user!.uid;

      // If student
      if (role == 'student') {
        if (studentId == null || studentId.isEmpty) {
          await userCredential.user!.delete();
          return {
            'success': false,
            'message': 'Student ID is required for students'
          };
        }

        // Add to pendingStudents (waiting for Admin approval)
        await _firestore.collection('pendingStudents').doc(uid).set({
          'name': name.trim(),
          'email': email.trim(),
          'studentId': studentId.trim(),
          'requestedAt': FieldValue.serverTimestamp(),
        });

        await _auth.signOut();
        return {
          'success': true,
          'message': 'Registration completed! Wait for admin approval',
          'role': 'student'
        };
      } else {
        // Admin or Teacher - direct registration
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
          'message': 'Registration successful!',
          'role': role,
          'uid': uid,
        };
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      if (e.code == 'weak-password') {
        message = 'Password is too weak (minimum 6 characters)';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email is already in use';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ============================================
  // Logout
  // ============================================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ============================================
  // Get current user
  // ============================================
  User? get currentUser => _auth.currentUser;

  // ============================================
  // Fetch current user data
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
