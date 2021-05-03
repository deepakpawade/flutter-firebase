import 'package:brew_crew/models/user_model.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

// FirebaseUser has been changed to User

// AuthResult has been changed to UserCredential

// GoogleAuthProvider.getCredential() has been changed
// to GoogleAuthProvider.credential()

// onAuthStateChanged which notifies about changes to
// the user's sign-in state was replaced with authStateChanges()

// currentUser() which is a method to retrieve the currently
// logged in user, was replaced with the property currentUser and it no
// longer returns a Future<FirebaseUser>
//
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // create user obj based on firebase user

//get only the userid
  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserModel> get user {
    //returns the logged in state of Users, if logged in then returns an user object else null
    return _auth.authStateChanges().map(_userFromFirebaseUser);
    //.map((User user) => _userFromFirebaseUser(user));
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      //create doc for user
      await DatabaseService(uid: user.uid).updateUserData('0', 'new', 100);

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
