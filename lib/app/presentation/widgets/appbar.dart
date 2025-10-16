import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawnco/app/core/constants/assets_path.dart';
import 'package:pawnco/app/core/themes/theme_helper.dart';
import 'package:pawnco/app/core/utils/gap_helper.dart';
import 'package:pawnco/app/presentation/widgets/small_button.dart';
import 'package:pawnco/app/routes/app_pages.dart';

class PawAppBar extends StatelessWidget {
  const PawAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              if (Get.currentRoute != Routes.HOME) {
                Get.offAllNamed(Routes.HOME);
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 4, 4),
                  child: Image.asset(AssetsPath.logo, width: 50),
                ),
                Gap.h8,
                Text(
                  'Paw & Co',
                  style: AppThemeHelper.font.headline(
                    color: AppThemeHelper.color.primary,
                  ),
                ),
              ],
            ),
          ),
          SmallButton.primary(
            label: 'New Pet',
            color: AppThemeHelper.color.primary,
            onTap: () {
              Get.toNamed(Routes.PET_INFO);
            },
            icon: Icons.add_circle_outline,
          ),
        ],
      ),
    );
  }
}
