import 'package:flutter/material.dart';
import 'package:i_billing/Configuration/app_colors.dart';

class ContractsPage extends StatelessWidget {
  static const id = '/contracts_page';

  const ContractsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparentWhite,
      appBar: AppBar(
        title: const Text('Contracts page'),
      ),
    );
  }
}
