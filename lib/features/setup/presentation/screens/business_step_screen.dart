import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../business/domain/entities/business_entity.dart';
import '../providers/setup_controller_provider.dart';
import 'setup_utils.dart';

class BusinessStepScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const BusinessStepScreen({super.key, required this.onNext});

  @override
  ConsumerState<BusinessStepScreen> createState() => _BusinessStepScreenState();
}

class _BusinessStepScreenState extends ConsumerState<BusinessStepScreen> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final existing = ref.read(setupControllerProvider).business?.name ?? '';
    _nameController = TextEditingController(text: existing);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(setupControllerProvider.notifier).updateBusiness(
          BusinessEntity(
            id: SetupUtils.generateLocalId(),
            name: _nameController.text.trim(),
            ownerId: '',
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
                  label: 'Business Name',
                  hint: 'e.g. Kodetech Enterprise',
                  controller: _nameController,
                  validator: (v) => Validators.required(v, 'Business name'),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => _submit(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submit,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}