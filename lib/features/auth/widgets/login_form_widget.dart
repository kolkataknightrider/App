// ════════════════════════════════════════════════════════════════
// FILE: lib/features/auth/widgets/login_form_widget.dart
// Member ID + password form with staggered entry animation,
// inline error shake and a morphing submit button.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/utils/validators.dart';
import 'package:partix/shared/widgets/custom_text_field.dart';
import 'package:partix/shared/widgets/custom_button.dart';
import 'package:partix/core/providers/providers.dart';

class LoginFormWidget extends ConsumerStatefulWidget {
  const LoginFormWidget({super.key});

  @override
  ConsumerState<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends ConsumerState<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _memberIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  /// Bumped on every failure so the card can replay its shake.
  int _shakeKey = 0;

  @override
  void dispose() {
    _memberIdCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      setState(() => _shakeKey++);
      return;
    }
    final auth = ref.read(authProvider);
    await auth.login(
      memberId: _memberIdCtrl.text.trim().toUpperCase(),
      password: _passwordCtrl.text,
    );
    if (auth.error != null && mounted) {
      setState(() => _shakeKey++);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(auth.error!)),
            ],
          ),
          backgroundColor: AppColors.error,
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
            prefixIcon: const Icon(Icons.badge_outlined),
            textCapitalization: TextCapitalization.characters,
            validator: Validators.validateMemberId,
          )
              .animate()
              .fadeIn(delay: 600.ms, duration: 450.ms)
              .slideY(begin: 0.35, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 14),
          CustomTextField(
            label: AppStrings.passwordLabel,
            controller: _passwordCtrl,
            obscureText: true,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            validator: Validators.validatePassword,
          )
              .animate()
              .fadeIn(delay: 720.ms, duration: 450.ms)
              .slideY(begin: 0.35, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 22),
          CustomButton(
            label: AppStrings.signInButton,
            icon: Icons.arrow_forward_rounded,
            isLoading: auth.status == AuthStatus.loading,
            enabled: !auth.isLockedOut,
            onPressed: _submit,
          )
              .animate()
              .fadeIn(delay: 840.ms, duration: 450.ms)
              .slideY(begin: 0.35, end: 0, curve: Curves.easeOutCubic),
        ],
      )
          .animate(key: ValueKey(_shakeKey))
          .shakeX(amount: _shakeKey == 0 ? 0 : 6, duration: 420.ms),
    );
  }
}
