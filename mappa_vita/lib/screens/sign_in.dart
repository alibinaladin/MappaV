import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

var scope = [
  'https://www.googleapis.com/auth/drive',
  'https://www.googleapis.com/auth/drive.file',
  'https://www.googleapis.com/auth/spreadsheets'
];

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(scopes: scope);

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print(user.displayName);
    return user;
  } catch (exce) {
    print(exce);
  }
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}

// old id is
//   1aRVvLFbpS1KYZddYHSgOGETP_ZuXqRYfPQsY7Vt-ynw
//   16QM6Etdow4uyySEx9IPjjhYSB0GctldazU-Twef_a2M
//   1MMYaTWtgp0JPgtZE3VVe8Lnq7tGP6ucTmZsI_QkkGEc
