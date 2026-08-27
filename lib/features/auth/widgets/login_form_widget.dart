// ════════════════════════════════════════════════════════════════
// FILE: lib/features/auth/widgets/login_form_widget.dart
// Member ID + password form (SECTION 6).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/providers/providers.dart';

class LoginFormWidget extends ConsumerStatefulWidget {
  const LoginFormWidget({super.key});

  @override
  ConsumerState<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends ConsumerState<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _memberIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _memberIdCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = ref.read(authProvider);
    await auth.login(
      memberId: _memberIdCtrl.text.trim().toUpperCase(),
      password: _passwordCtrl.text,
    );
    if (auth.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
          backgroundColor: Colors.redAccent,
        ),
      );
      auth.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: AppStrings.memberIdLabel,
            hint: AppStrings.memberIdHint,
            controller: _memberIdCtrl,
            prefixIcon: const Icon(Icons.person_outline),
            textCapitalization: TextCapitalization.characters,
            validator: Validators.validateMemberId,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: AppStrings.passwordLabel,
            controller: _passwordCtrl,
            obscureText: true,
            prefixIcon: const Icon(Icons.lock_outline),
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 24),
          CustomButton(
            label: AppStrings.signInButton,
            isLoading: auth.status == AuthStatus.loading,
            onPressed: auth.isLockedOut ? null : _submit,
          ),
        ],
      ),
    );
  }
}
