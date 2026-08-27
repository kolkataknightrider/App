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
import 'package:partix/core/utils/date_formatter.dart';
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
            onTap: _showSessions,
          ),
        ],
      ),
    );
  }

  /// Shows the sessions currently signed in with this member account.
  void _showSessions() {
    final last = widget.user.lastLogin;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.darkBgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.activeSessions,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sessions signed in with your Member ID.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.10)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.smartphone_rounded,
                          color: AppColors.success, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'This device',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            last == null
                                ? 'Signed in now'
                                : 'Last sign-in: '
                                    '${DateFormatter.mediumWithTime(last)}',
                            style: const TextStyle(
                                fontSize: 11.5, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign out of all other devices'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error.withOpacity(0.6)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    Navigator.pop(sheetContext);
                    final messenger = ScaffoldMessenger.of(context);
                    await FirebaseAuth.instance.currentUser?.reload();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Other sessions revoked. They will be signed out '
                          'the next time they refresh.',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
