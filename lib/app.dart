import 'package:flutter/material.dart';

import 'Application/Main/View/main_page.dart';
import 'Application/Welcome/SignIn/View/sign_in_page.dart';
import 'Application/Welcome/SignUp/View/sign_up_page.dart';
import 'Application/Welcome/Splash/splash_page.dart';
import 'Application/Welcome/Start/View/start_page.dart';
import 'Configuration/app_colors.dart';
import 'Data/Service/db_service.dart';
import 'Data/Service/init_service.dart';

class IBilling extends StatelessWidget {
  final Future _initFuture = Init.initialize();

  IBilling({super.key});

  Widget _startPage() {
    return FutureBuilder(
      future: DBService.loadData(StorageKey.user),
      builder: (context, snapshot) {
        if (true) {
          return MainPage();
        } else {
          return const StartPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'IBilling',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.blue),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _startPage();
          } else {
            return const SplashPage();
          }
        },
      ),
      routes: {
        StartPage.id: (context) => const StartPage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
      },
    );
  }
}
