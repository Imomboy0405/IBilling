import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  static const id = '/history_page';

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History page'),
      ),
    );
  }
}