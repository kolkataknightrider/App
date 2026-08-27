// ════════════════════════════════════════════════════════════════
// FILE: lib/features/profile/screens/profile_screen.dart
// SECTION 11 — complete profile screen.
// ════════════════════════════════════════════════════════════════

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/firebase/firestore_service.dart';
import 'package:partix/core/firebase/storage_service.dart';
import 'package:partix/core/services/offline_sync_service.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/shared/widgets/section_card.dart';
import 'package:partix/features/profile/widgets/profile_header_widget.dart';
import 'package:partix/features/profile/widgets/personal_info_section.dart';
import 'package:partix/features/profile/widgets/upi_details_section.dart';
import 'package:partix/features/profile/widgets/bank_details_section.dart';
import 'package:partix/features/profile/widgets/security_section.dart';
import 'package:partix/features/profile/widgets/app_settings_section.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _pickPhoto() async {
    final user = ref.read(userProvider).user;
    if (user == null) return;
    final file = await StorageService.instance.pickImage();
    if (file == null) return;
    final url =
        await StorageService.instance.uploadProfilePhoto(user.uid, file);
    ref.read(userProvider).setUser(user.copyWith(profilePhotoUrl: url));
    await FirestoreService.instance.updateUser(user.uid, {
      'profilePhotoUrl': url,
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).user;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(user: user, onPickPhoto: _pickPhoto),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                children: [
                  PersonalInfoSection(user: user),
                  SectionCard(
                    title: AppStrings.referralCode,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.referralCode,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: user.referralCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied')),
                            );
                          },
                          child: const Text(AppStrings.copy),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => Share.share(
                            'Join my PARTIX network! Referral: ${user.referralCode}',
                          ),
                          child: const Text(AppStrings.shareReferral),
                        ),
                      ],
                    ),
                  ),
                  UpiDetailsSection(user: user),
                  BankDetailsSection(user: user),
                  SecuritySection(user: user),
                  AppSettingsSection(user: user),
                  SectionCard(
                    title: AppStrings.support,
                    child: Column(
                      children: [
                        _supportTile(Icons.chat, AppStrings.whatsappSupport,
                            () => _launch(AppStrings.supportWhatsAppUrl)),
                        _supportTile(Icons.email, AppStrings.emailSupport,
                            () => _launch('mailto:support@partix.com')),
                        _supportTile(
                            Icons.description,
                            AppStrings.terms,
                            () => _showDoc(
                                AppStrings.terms, AppStrings.termsText)),
                        _supportTile(
                            Icons.privacy_tip,
                            AppStrings.privacy,
                            () => _showDoc(
                                AppStrings.privacy, AppStrings.privacyText)),
                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.info_outline,
                              color: AppColors.brandPrimary),
                          title: Text('${AppStrings.appVersion}: '
                              '${AppStrings.appVersion}'),
                        ),
                      ],
                    ),
                  ),

                  // ── Logout ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text(AppStrings.logout),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(
                            double.infinity, AppDimensions.buttonHeight),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportTile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.brandPrimary),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// Full-height scrollable legal document sheet.
  void _showDoc(String title, String body) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, controller) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkBgSecondary.withOpacity(0.92),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.14)),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      children: [
                        Text(
                          body,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(authProvider).logout();
      await OfflineSyncService.instance.clearAll();
    }
  }
}
