import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/till_status.dart';
import '../../../till/domain/entities/till_entity.dart';
import '../providers/setup_controller_provider.dart';
import 'setup_utils.dart';

class TillStepScreen extends ConsumerStatefulWidget {
  const TillStepScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  ConsumerState<TillStepScreen> createState() => _TillStepScreenState();
}

class _TillStepScreenState extends ConsumerState<TillStepScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  MobileNetwork? _network;

  @override
  void initState() {
    super.initState();
    final till = ref.read(setupControllerProvider).till;
    _nameController = TextEditingController(text: till?.name ?? '');
    _phoneController = TextEditingController(text: till?.phoneNumber ?? '');
    _network = till?.network;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final network = _network;
    if (network == null) return;
    ref.read(setupControllerProvider.notifier).updateTill(
          TillEntity(
            id: SetupUtils.generateLocalId(),
            branchId: '',
            name: _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            network: network,
            status: TillStatus.active,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Display Name',
                      hint: 'e.g. Till 1',
                      controller: _nameController,
                      validator: (v) => Validators.required(v, 'Display name'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mobile Network',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final network in MobileNetwork.values)
                          ChoiceChip(
                            label: Text(network.shortName),
                            selected: _network == network,
                            onSelected: (_) =>
                                setState(() => _network = network),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Till Number',
                      hint: 'e.g. 0240000000',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: Validators.phone,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                    ),
                  ],
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