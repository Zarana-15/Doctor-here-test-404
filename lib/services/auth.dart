import 'package:doctor_here/model/user.dart';
//import 'package:doctor_here/screens/doctorHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:doctor_here/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

// Sign in through google
Future<bool> signInWithGoogle() async {
  //print('hi');

  bool userSignedIn = await googleSignIn.isSignedIn();
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  //print("uid ::::" + user.uid);
  DatabaseService(uid: user.uid);
  User(uid: user.uid);

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return userSignedIn;
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}

void signOut() async {
  await _auth.signOut();
  
}

// class AuthService {
//create user obj based on FirebaseUser
// User _userFromFilebaseUser(FirebaseUser user) {
//   return user != null ? User(uid: user.uid) : null;
// }

// //auth change user stream
// Stream<User> get user {
//   return _auth.onAuthStateChanged
//       //.map((FirebaseUser user) => _userFromFilebaseUser(user));
//       .map(_userFromFilebaseUser);
// }

//sign in with email and password
//   Future signInWithEmailAndPassword(String email, String password) async {
//     try {
//       AuthResult result = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       FirebaseUser user = result.user;
//       return _userFromFilebaseUser(user);
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   //register with email and password
//   /* Future registerWithEmailAndPassword(String email, String password) async {
//     try {
//       AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       FirebaseUser user = result.user;

//       await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
//       return _userFromFilebaseUser(user);
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }*/

//   //signout
//   Future signOut() async {
//     try {
//       return await _auth.signOut();
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
// }
