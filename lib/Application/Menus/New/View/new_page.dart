import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  static const id = '/new_page';

  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New page'),
      ),
    );
  }
}