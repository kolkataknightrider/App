// ════════════════════════════════════════════════════════════════
// FILE: lib/features/profile/widgets/upi_details_section.dart
// SECTION 11 — UPI account management.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/core/firebase/firestore_service.dart';
import 'package:partix/core/utils/validators.dart';
import 'package:partix/shared/widgets/section_card.dart';
import 'package:partix/shared/widgets/status_badge.dart';

class UpiDetailsSection extends ConsumerStatefulWidget {
  final UserModel user;
  const UpiDetailsSection({super.key, required this.user});

  @override
  ConsumerState<UpiDetailsSection> createState() => _UpiDetailsSectionState();
}

class _UpiDetailsSectionState extends ConsumerState<UpiDetailsSection> {
  final _idCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _openDialog() {
    _idCtrl.text = widget.user.upiDetails?.upiId ?? '';
    _nameCtrl.text = widget.user.upiDetails?.upiName ?? '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            Text(widget.user.upiDetails == null ? 'Add UPI ID' : 'Edit UPI ID'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _idCtrl,
              decoration: const InputDecoration(labelText: 'UPI ID'),
            ),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final err = Validators.validateUpi(_idCtrl.text);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), backgroundColor: Colors.redAccent));
      return;
    }
    // Capture navigator/messenger before the await so we never touch a
    // BuildContext across an async gap.
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    await FirestoreService.instance.updateUpiDetails(widget.user.uid, {
      'upiId': _idCtrl.text.trim(),
      'upiName': _nameCtrl.text.trim(),
      'isVerified': false,
    });
    navigator.pop();
    ref.read(userProvider).setUser(widget.user.copyWith(
          upiDetails: UpiDetailsModel(
            upiId: _idCtrl.text.trim(),
            upiName: _nameCtrl.text.trim(),
            isVerified: false,
          ),
        ));
    messenger.showSnackBar(const SnackBar(content: Text('UPI details saved')));
  }

  @override
  Widget build(BuildContext context) {
    final upi = widget.user.upiDetails;
    return SectionCard(
      title: AppStrings.upiAccount,
      trailing: TextButton(
        onPressed: _openDialog,
        child: Text(upi == null ? 'Add' : 'Edit'),
      ),
      child: upi == null
          ? const Text('No UPI ID added',
              style: TextStyle(color: AppColors.textSecondary))
          : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(upi.upiId,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      Text(upi.upiName,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
                StatusBadge.status(upi.isVerified ? 'verified' : 'pending'),
              ],
            ),
    );
  }
}
