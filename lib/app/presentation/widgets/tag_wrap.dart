import 'package:flutter/material.dart';
import 'package:pawnco/app/core/themes/theme_helper.dart';
import 'package:pawnco/app/domain/entities/tags.dart';

class TagWrap extends StatelessWidget {
  const TagWrap({super.key, required this.tags});

  final List<Tags> tags;

  Widget _buildChip(String tagName) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppThemeHelper.color.secondary,
      ),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Text(
        tagName,
        style: AppThemeHelper.font.description(
          color: AppThemeHelper.color.textSecondary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      children: tags.map((e) => _buildChip(e.name ?? '')).toList(),
    );
  }
}
