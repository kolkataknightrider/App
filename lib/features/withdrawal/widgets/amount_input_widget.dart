// ════════════════════════════════════════════════════════════════
// FILE: lib/features/withdrawal/widgets/amount_input_widget.dart
// SECTION 10 — amount entry + quick-select chips.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/utils/currency_formatter.dart';

class AmountInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final double maxAmount;
  final ValueChanged<String>? onChanged;

  const AmountInputWidget({
    super.key,
    required this.controller,
    required this.maxAmount,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final quick = [500, 1000, 2500, 5000, 10000];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(AppStrings.enterAmount,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          ),
          child: Row(
            children: [
              const Text('₹',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(AppStrings.quickSelect,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...quick.map((q) => _chip(
                  CurrencyFormatter.formatCompact(q.toDouble()),
                  () => controller.text = q.toString(),
                )),
            _chip(AppStrings.max, () => controller.text = maxAmount.toString()),
          ],
        ),
      ],
    );
  }

  Widget _chip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.brandPrimary.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style:
                const TextStyle(color: AppColors.brandPrimary, fontSize: 12)),
      ),
    );
  }
}
