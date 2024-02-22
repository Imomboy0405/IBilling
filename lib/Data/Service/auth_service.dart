import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static String verificationId = '';

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? gAuth = await gUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth?.accessToken,
      idToken: gAuth?.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  static Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login( );

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  static Future<UserCredential> createUser(String email, String password) async {
    _auth.signOut();
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credentials) async {
        await _auth.signInWithCredential(credentials);
      },
      verificationFailed: (e) {
        if(e.code == 'invalid-phone-number') {
          // todo error msg
        } else {
          // todo try msg
          print('==========================errorku');
          print(e.code);
        }
      },
      codeSent: (vId, resendToken) {
        verificationId = vId;
        print('===========================sms sent');
      },
      codeAutoRetrievalTimeout: (vId) {
        verificationId = vId;
      },
      timeout: const Duration(seconds: 120),
    );
  }

  static Future<bool> verifyOTP(String otp) async {
    UserCredential credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        ));
    return credentials.user != null ? true : false;
  }

  static Future<void> verifyEmail(String email) async {
    await _auth.currentUser?.sendEmailVerification();
    print('email=${_auth.currentUser?.email}');

    // await _auth.sendSignInLinkToEmail(
    //     email: email,
    //     actionCodeSettings: ActionCodeSettings(
    //       url: 'https://ibilling-d45ee.firebaseapp.com',
    //       androidInstallApp: true,
    //       handleCodeInApp: true,
    // ));
  }

  static Future<bool> verifyEmailLink() async {
    await _auth.currentUser!.reload();
    return _auth.currentUser!.emailVerified;
  }
}
