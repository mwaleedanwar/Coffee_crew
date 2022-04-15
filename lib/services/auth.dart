import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //create User object based on Firebase User
  customUser _userFromFirebaseUser(User user) {
    return customUser(user.uid);
  }

  //auth change user stream
  Stream<customUser> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User user = userCredential.user!;
      return _userFromFirebaseUser(user).uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in email & pwd
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user == null) {
        return null;
      } else {
        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & pwd

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      //create new instance/document for new uid

      if (user == null) {
        return null;
      } else {
        await DatabaseService(user.uid)
            .updateUserdata('0', 'new crew memeber', 100);
        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
