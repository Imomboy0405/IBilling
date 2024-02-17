import 'package:google_sign_in/google_sign_in.dart';

Future<String?> signInWithGoogle() async {

  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Map<String, String?> data = {
    // "accessToken": googleAuth?.accessToken,
    // "idToken": googleAuth?.idToken,
  // };

  // Once signed in, return the UserCredential
  return googleUser?.email;
}