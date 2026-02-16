import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'package:quickseatreservation/app/constants/AppCollections.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        throw Exception("Login failed: User is null");
      }

      final DocumentSnapshot userDoc = await _firestore
          .collection(AppCollections.users)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("User data not found in Firestore");
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final String role = userData['role'] ?? '';

      if (role != 'admin') {
        // Sign out if not admin to prevent session persistence
        await _firebaseAuth.signOut();
        throw Exception("Access Denied: You do not have admin privileges.");
      }

      return UserModel.fromFirestore(userData, userCredential.user!.uid);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final DocumentSnapshot userDoc = await _firestore
        .collection(AppCollections.users)
        .doc(user.uid)
        .get();

    if (!userDoc.exists) return null;

    return UserModel.fromFirestore(
      userDoc.data() as Map<String, dynamic>,
      user.uid,
    );
  }
}
