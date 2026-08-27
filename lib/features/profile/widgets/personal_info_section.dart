// ════════════════════════════════════════════════════════════════
// FILE: lib/features/profile/widgets/personal_info_section.dart
// SECTION 11 — personal information (view + edit).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/providers/providers.dart';
import '../../../../shared/widgets/section_card.dart';

class PersonalInfoSection extends ConsumerStatefulWidget {
  final UserModel user;
  const PersonalInfoSection({super.key, required this.user});

  @override
  ConsumerState<PersonalInfoSection> createState() =>
      _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends ConsumerState<PersonalInfoSection> {
  bool _editing = false;
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.user.fullName);
    _phone = TextEditingController(text: widget.user.phone);
    _address = TextEditingController(text: widget.user.address ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppStrings.personalInformation,
      trailing: TextButton(
        onPressed: _editing
            ? _save
            : () => setState(() => _editing = true),
        child: Text(_editing ? 'Save' : 'Edit'),
      ),
      child: _editing
          ? Column(
              children: [
                _field('Full Name', _name),
                const SizedBox(height: 10),
                _field('Phone', _phone),
                const SizedBox(height: 10),
                _field('Address', _address),
              ],
            )
          : Column(
              children: [
                _row('Full Name', widget.user.fullName),
                _row('Phone', widget.user.phone),
                _row('Email', widget.user.email),
                _row('Address', widget.user.address ?? '—'),
              ],
            ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return TextField(
      controller: c,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    await ref.read(userProvider).updateProfile(
          fullName: _name.text,
          phone: _phone.text,
          address: _address.text,
        );
    setState(() => _editing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    }
  }
}
