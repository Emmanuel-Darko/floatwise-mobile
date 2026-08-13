import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/setup_controller_provider.dart';

class OpeningBalanceStepScreen extends ConsumerStatefulWidget {
  const OpeningBalanceStepScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  ConsumerState<OpeningBalanceStepScreen> createState() =>
      _OpeningBalanceStepScreenState();
}

class _OpeningBalanceStepScreenState
    extends ConsumerState<OpeningBalanceStepScreen> {
  late final TextEditingController _cashController;
  late final TextEditingController _floatController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final state = ref.read(setupControllerProvider);
    _cashController = TextEditingController(
      text: state.openingCash != null ? state.openingCash.toString() : '',
    );
    _floatController = TextEditingController(
      text: state.openingFloat != null ? state.openingFloat.toString() : '',
    );
  }

  @override
  void dispose() {
    _cashController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref
        .read(setupControllerProvider.notifier)
        .updateOpeningBalances(
          cash: double.parse(_cashController.text.trim()),
          floatBalance: double.parse(_floatController.text.trim()),
        );
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Opening Cash (GHS)',
                      hint: 'e.g. 5000',
                      controller: _cashController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: Validators.amount,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Opening Float (GHS)',
                      hint: 'e.g. 10000',
                      controller: _floatController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: Validators.amount,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _submit, child: const Text('Continue')),
          ],
        ),
      ),
    );
  }
}
