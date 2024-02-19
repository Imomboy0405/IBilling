import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:i_billing/app.dart';

import 'Data/Service/locator_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDxiWlLQvAgrXi4mOBMcC0zwFSHMgdJDF4",
      appId: "1:1075100669403:android:97160985b9332ca8ac43fe",
      messagingSenderId: "XXX",
      projectId: "ibilling-d45ee",
      androidClientId: "1075100669403-6av2o0hphf4mtr85jmv2bsl9hs4s9213.apps.googleusercontent.com",
    ),
  );
  await setupLocator();

  runApp(IBilling());
}