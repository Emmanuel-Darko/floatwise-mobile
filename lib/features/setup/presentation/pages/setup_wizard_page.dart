import 'package:flutter/material.dart';

class SetupWizardPage extends StatelessWidget {
  const SetupWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup')),
      body: const Center(
        child: Text('Setup Wizard'),
      ),
    );
  }
}