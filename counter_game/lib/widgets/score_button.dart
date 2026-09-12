import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ScoreButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const ScoreButton({
    super.key,
    required this.onPressed,
    this.label = '+1',
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              enabled ? AppColors.primary : AppColors.disabled,
          foregroundColor:
              enabled ? AppColors.textOnPrimary : AppColors.disabledText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
