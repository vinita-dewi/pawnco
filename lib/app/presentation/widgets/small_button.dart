import 'package:flutter/material.dart';
import 'package:pawnco/app/core/themes/theme_helper.dart';
import 'package:pawnco/app/core/utils/gap_helper.dart';

enum _SmallButtonVariant { primary, outlined }

class SmallButton extends StatelessWidget {
  const SmallButton({
    super.key,
    required this.label,
    this.onTap = null,
    this.icon,
    required this.color,
    required _SmallButtonVariant variant,
  }) : _variant = variant;

  const SmallButton.primary({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    required this.color,
  }) : _variant = _SmallButtonVariant.primary;

  const SmallButton.outlined({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    required this.color,
  }) : _variant = _SmallButtonVariant.outlined;
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color color;
  final _SmallButtonVariant _variant;

  bool get _isPrimary => _variant == _SmallButtonVariant.primary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        backgroundColor: _isPrimary ? color : AppThemeHelper.color.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: _isPrimary ? null : BorderSide(color: color, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: _isPrimary ? AppThemeHelper.color.background : color,
              size: 16,
            ),
            Gap.h8,
          ],
          Text(
            label,
            style: AppThemeHelper.font.body(
              color: _isPrimary ? AppThemeHelper.color.background : color,
            ),
          ),
        ],
      ),
    );
  }
}
