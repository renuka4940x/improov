// ignore_for_file: await_only_futures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:improov/dataconnect_generated/generated.dart';
import 'package:improov/src/data/database/cloud_backup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final Ref ref;
  
  User? _currentUser;

  AuthService(this.ref) {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  //SIGN UP
  Future<UserCredential?> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );

      if (userCredential.user != null) {
        // Sync the new user to Postgres
        await _syncUserToPostgres(
          userCredential.user!, 
          username: username,
          isPremium: false,
        );
      }
      return userCredential;
    } catch (e) {
      debugPrint("Sign Up Error: $e");
      rethrow;
    }
  }

  //LOG IN (Email/Password)
  Future<UserCredential?> logIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      debugPrint("Log In Error: $e");
      rethrow;
    }
  }

  //GOOGLE SIGN IN
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return null; 

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Sync the Google user to Postgres
        await _syncUserToPostgres(
          userCredential.user!, 
          isPremium: false
        );
      }
      return userCredential;
    } catch (e) {
      debugPrint("Google Sign In Error: $e");
      rethrow;
    }
  }

  // POSTGRES CLOUD SYNC & BULK DATA MIGRATION
  Future<void> _syncUserToPostgres(
    User user, 
    {String? username, 
    required bool isPremium}
  ) async {
    try {
      await ExampleConnector.instance.createUser(
        id: user.uid,
        username: username ?? user.displayName ?? "Improover",
        email: user.email ?? "",
        passwordHash: "managed_by_firebase", 
        createdAt: Timestamp.fromJson(DateTime.now().toUtc().toIso8601String()),
      ).execute();
      
      debugPrint("User profile synced to Postgres Cloud!");

      if (isPremium) {
        debugPrint("💎 Premium detected! Starting bulk migration...");
        await syncAllLocalDataToCloud(ref); 
      }

    } catch (e) {
      debugPrint("Cloud Sync Failed: $e");
    }
  }

  //LOG OUT
  Future<void> logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}