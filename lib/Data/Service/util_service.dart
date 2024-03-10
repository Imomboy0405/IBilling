import 'package:flutter/material.dart';
import 'package:i_billing/Configuration/app_colors.dart';
import 'package:i_billing/Configuration/app_text_styles.dart';

class Utils {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar({
    required String txt,
    required BuildContext context,
    bool errorState = false,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        content: Container(
          width: MediaQuery.of(context).size.width - 100,
          height: 44,
          margin: const EdgeInsets.only(bottom: 80),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: errorState ? AppColors.red : AppColors.blue, borderRadius: BorderRadius.circular(6)),
          child: Text(txt, style: AppTextStyles.style13(context).copyWith(color: Colors.white), textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
