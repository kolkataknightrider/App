// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/custom_text_field.dart
// Frosted input with animated focus glow, floating label and a
// built-in password visibility toggle.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partix/core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.inputFormatters,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _hidden = true;
  bool _focused = false;
  final _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _node.addListener(() {
      if (mounted) setState(() => _focused = _node.hasFocus);
    });
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AppColors.brandPrimary.withOpacity(0.28),
                  blurRadius: 18,
                  spreadRadius: -4,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        focusNode: _node,
        controller: widget.controller,
        validator: widget.validator,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText ? _hidden : false,
        onChanged: widget.onChanged,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        cursorColor: AppColors.brandAccent,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'Poppins',
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          filled: true,
          fillColor: Colors.white.withOpacity(_focused ? 0.10 : 0.055),
          prefixIcon: widget.prefixIcon == null
              ? null
              : IconTheme(
                  data: IconThemeData(
                    color: _focused
                        ? AppColors.brandAccent
                        : AppColors.textSecondary,
                    size: 20,
                  ),
                  child: widget.prefixIcon!,
                ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  splashRadius: 20,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      _hidden
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      key: ValueKey(_hidden),
                      size: 19,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() => _hidden = !_hidden);
                  },
                )
              : null,
          labelStyle: TextStyle(
            color: _focused ? AppColors.brandAccent : AppColors.textSecondary,
            fontFamily: 'Poppins',
            fontSize: 13.5,
          ),
          floatingLabelStyle: const TextStyle(
            color: AppColors.brandAccent,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          hintStyle: const TextStyle(
              color: AppColors.textTertiary, fontFamily: 'Poppins'),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: AppColors.brandPrimary, width: 1.6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.error, width: 1.4),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.error, width: 1.6),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
        ),
      ),
    );
  }
}
