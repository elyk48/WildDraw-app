import 'package:firebase_auth/firebase_auth.dart';
class AuthenticationService{
final FirebaseAuth _firebaseAuth;

  //Initialise this Service as FirebaseAuth
  AuthenticationService(this._firebaseAuth);

  //Stream to check the State changes in users
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();


  //SignIn function
  Future<String> signIn({required String email, required String password})async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    }on FirebaseAuthException catch(e){
        return e.message.toString();
    }
  }
//SignUp function
Future<String> signUp({required String email, required String password})async{
  try {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return "Signed up";
  }on FirebaseAuthException catch(e){
    return e.message.toString();
  }
}
//SignOut function
Future<void> signOut()async {
    await _firebaseAuth.signOut();
}
}