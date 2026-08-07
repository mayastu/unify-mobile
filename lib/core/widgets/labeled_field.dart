import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A bold label sitting above a field — "Username", "New Password"...
/// as their own line, matching the design (not a floating Material
/// label inside the field).
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.field,
  });

  final String label;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}