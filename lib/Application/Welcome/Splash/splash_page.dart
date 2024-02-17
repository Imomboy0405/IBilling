import 'package:flutter/material.dart';

import '../../../Configuration/app_colors.dart';
import '../../../Configuration/app_text_styles.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Text('IBilling', style: AppTextStyles.style0,),
      ),
    );
  }
}