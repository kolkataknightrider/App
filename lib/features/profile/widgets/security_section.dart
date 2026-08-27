// ════════════════════════════════════════════════════════════════
// FILE: lib/features/profile/widgets/security_section.dart
// SECTION 11 — security: change password + biometric toggle.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/core/firebase/auth_service.dart';
import 'package:partix/shared/widgets/section_card.dart';

class SecuritySection extends ConsumerStatefulWidget {
  final UserModel user;
  const SecuritySection({super.key, required this.user});

  @override
  ConsumerState<SecuritySection> createState() => _SecuritySectionState();
}

class _SecuritySectionState extends ConsumerState<SecuritySection> {
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppStrings.security,
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading:
                const Icon(Icons.lock_outline, color: AppColors.brandPrimary),
            title: const Text(AppStrings.changePassword),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changePassword,
          ),
          const Divider(height: 1),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary:
                const Icon(Icons.fingerprint, color: AppColors.brandPrimary),
            title: const Text(AppStrings.biometricLogin),
            value: widget.user.biometricEnabled,
            onChanged: (v) async {
              await ref
                  .read(userProvider)
                  .updatePreferences(biometricEnabled: v);
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.devices, color: AppColors.brandPrimary),
            title: const Text(AppStrings.activeSessions),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('2 devices active')),
            ),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                final email = AuthService.memberIdToEmail(widget.user.memberId);
                final cred = EmailAuthProvider.credential(
                  email: email,
                  password: oldCtrl.text,
                );
                await FirebaseAuth.instance.currentUser
                    ?.reauthenticateWithCredential(cred);
                await FirebaseAuth.instance.currentUser
                    ?.updatePassword(newCtrl.text);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password updated')));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Failed: ${e.toString()}'),
                      backgroundColor: Colors.redAccent));
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
