import 'package:flutter/material.dart';
import 'package:pawnco/app/core/themes/theme_helper.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: AppThemeHelper.color.textSecondary.withValues(alpha: 0.5),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
