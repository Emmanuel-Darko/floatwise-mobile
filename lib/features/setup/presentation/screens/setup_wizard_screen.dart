import 'package:flutter/material.dart';

import 'business_step_screen.dart';
import 'branch_step_screen.dart';
import 'till_step_screen.dart';
import 'opening_balance_step_screen.dart';
import 'review_step_screen.dart';

class SetupWizardScreen extends StatefulWidget {
  const SetupWizardScreen({super.key});

  @override
  State<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends State<SetupWizardScreen> {
  int _step = 0;

  void _goToNext() => setState(() => _step++);

  void _goBack() => setState(() => _step--);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup'),
        leading: _step > 0
            ? IconButton(onPressed: _goBack, icon: const Icon(Icons.arrow_back))
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _step,
                children: [
                  BusinessStepScreen(onNext: _goToNext),
                  BranchStepScreen(onNext: _goToNext),
                  TillStepScreen(onNext: _goToNext),
                  OpeningBalanceStepScreen(onNext: _goToNext),
                  const ReviewStepScreen(),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _step > 0
                        ? OutlinedButton(
                            onPressed: _goBack,
                            child: const Text('Back'),
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (_step > 0) const SizedBox(width: 12),
                  Text('Step ${_step + 1} of $_numberOfSteps'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int get _numberOfSteps => 5;
}
