import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _firebase = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredentials = await _firebase.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredentials.user;
  }

  Future<User?> signInEmailAndPassword(String email, String password) async {
    final userCredentials = await _firebase.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredentials.user;
  }
}
