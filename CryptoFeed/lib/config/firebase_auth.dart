import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import '../firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

final GoogleSignInAccount? user = _googleSignIn.currentUser;

