import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:apple_sign_in/apple_sign_in.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Determine if Apple SignIn is available
  // Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  //Firebase fetch the user one-time
  Future<FirebaseUser> get getUser => _auth.currentUser();

  //Firebase user as a realtime stream(Recommended by Jeff)
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  //Anonymous login
  Future<FirebaseUser> anonLogin() async {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;

    updateUserData(user);
    return user;
  }
  
  //Google sign-in
  Future<FirebaseUser> googleSignIn() async {
    try { //Try catch is used to handle any unexpected interuptions in the sign in process
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn(); //User is redirected to google login window
      GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication; //After login we receive the user login data
    
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, 
        accessToken: googleAuth.accessToken
        ); //This credential is what we send to firebase 

      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;

      //Update our user data
      updateUserData(user);

     return user;
    } catch(err) {
        print(err);
        throw new Error();
    }
  }

  /// Sign in with Apple
  // Future<FirebaseUser> appleSignIn() async {
  //   try {

  //     final AuthorizationResult appleResult = await AppleSignIn.performRequests([//Request to authenticate user
  //       AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //     ]);

  //     if (appleResult.error != null) {
  //       // handle errors from Apple here
  //     }

  //     final AuthCredential credential = OAuthProvider(providerId: 'apple.com').getCredential(//Creating auth credential for firebase
  //       accessToken: String.fromCharCodes(appleResult.credential.authorizationCode),//converting tokens to strings for firebase
  //       idToken: String.fromCharCodes(appleResult.credential.identityToken),
  //     );

  //     AuthResult firebaseResult = await _auth.signInWithCredential(credential);
  //     FirebaseUser user = firebaseResult.user;

  //     // Optional, Update user data in Firestore
  //     updateUserData(user);

  //     return user;
  //   } catch (error) {
  //     print(error);
  //     throw new Error();
  //   }
  // }

  //Writes to the database to track progress through the quizzes in the app
  Future<void> updateUserData(FirebaseUser user) {
    DocumentReference reportRef = _db.collection('reports').document(user.uid); //We reference the user document here

    return reportRef.setData({
      'uid': user.uid,
      'lastActivity': DateTime.now()
    }, merge: true);//merge true tells firebase not to overwrite data if it already exists(important!)

  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  
   
}
