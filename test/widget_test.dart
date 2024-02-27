import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_billing/Data/Model/user_model.dart';
import 'package:i_billing/Data/Service/network_service.dart';
import 'package:i_billing/app.dart';

void main() {

  test('Post', () async {
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
    runApp(IBilling());

    UserModel userModel = UserModel(
      email: '1',
      phoneNumber: '32',
      uId: 'my_id',
      password: 'pas',
      fullName: 'Ismim',
      createdTime: '',
    );
    String? error = await NetworkService.POST('users', userModel.uId!, userModel.toJson());
    print('==========$error');
  });
}
