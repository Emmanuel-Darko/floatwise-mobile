import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../branch/domain/entities/branch_entity.dart';
import '../providers/setup_controller_provider.dart';
import 'setup_utils.dart';

class BranchStepScreen extends ConsumerStatefulWidget {
  const BranchStepScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  ConsumerState<BranchStepScreen> createState() => _BranchStepScreenState();
}

class _BranchStepScreenState extends ConsumerState<BranchStepScreen> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final existing = ref.read(setupControllerProvider).branch?.name ?? '';
    _nameController = TextEditingController(text: existing);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref
        .read(setupControllerProvider.notifier)
        .updateBranch(
          BranchEntity(
            id: SetupUtils.generateLocalId(),
            businessId: '',
            name: _nameController.text.trim(),
            createdAt: DateTime.now(),
          ),
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
                child: AppTextField(
                  label: 'Branch Name',
                  hint: 'e.g. East Legon',
                  controller: _nameController,
                  validator: (v) => Validators.required(v, 'Branch name'),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
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
