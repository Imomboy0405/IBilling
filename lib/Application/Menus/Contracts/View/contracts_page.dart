import 'package:flutter/material.dart';

class ContractsPage extends StatelessWidget {
  static const id = '/contracts_page';

  const ContractsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contracts page'),
      ),
    );
  }
}
