import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class MyAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  MyAuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // ฟังก์ชันสมัครสมาชิก
  Future<String?> registerUser(String username, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: "$username@tsu.test",
        password: password,
      );
      return null; // ไม่มี error แปลว่าสำเร็จ
    } catch (e) {
      return e.toString();
    }
  }

  // ฟังก์ชันล็อกอิน
  Future<String?> loginUser(String username, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: "$username@tsu.test",
        password: password,
      );
      return null; // ไม่มี error แปลว่าสำเร็จ
    } catch (e) {
      return e.toString();
    }
  }

  // ฟังก์ชันล็อกเอาต์
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return 'User cancelled login';
      
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      await FirebaseAuth.instance.signInWithCredential(credential);
      return null;
    } catch (e) {
      return 'Google sign in failed: $e';
    }
  }
}