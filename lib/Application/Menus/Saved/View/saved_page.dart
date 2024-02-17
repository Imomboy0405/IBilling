import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget {
  static const id = '/saved_page';

  const SavedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved page'),
      ),
    );
  }
}
