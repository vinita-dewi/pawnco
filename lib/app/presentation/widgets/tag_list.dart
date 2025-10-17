import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawnco/app/core/themes/theme_helper.dart';
import 'package:pawnco/app/core/utils/gap_helper.dart';
import 'package:pawnco/app/domain/entities/tags.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';
import 'package:pawnco/app/presentation/mobile/pet_list/controllers/pet_list_controller.dart';

class TagList extends GetView<PetListController> {
  const TagList({super.key});

  Widget _buildChip({
    required String tagName,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: AppThemeHelper.color.secondary.withValues(
            alpha: selected ? 1 : 0.2,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Text(
          tagName,
          style: AppThemeHelper.font.description(
            color: AppThemeHelper.color.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.only(left: 20),
      child: Obx(() {
        return controller.fetchState == FetchState.loading
            ? SizedBox()
            : ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: controller.tags.length,
              itemBuilder: (context, idx) {
                return Obx(() {
                  Tags tag = controller.tags[idx];
                  return _buildChip(
                    tagName: controller.tags[idx].name ?? '',
                    selected: controller.selectedTags.contains(tag.name),
                    onTap: () {
                      if (controller.selectedTags.contains(tag.name)) {
                        controller.selectedTags.remove(tag.name);
                      } else {
                        controller.selectedTags.add(tag.name!);
                      }

                      if (controller.selectedTags.isEmpty) {
                        controller.loadPets();
                      } else {
                        controller.loadPetsByTag();
                      }

                      debugPrint('selectedTags : ${controller.selectedTags}');
                    },
                  );
                });
              },
              separatorBuilder: (context, idx) {
                return Gap.h8;
              },
            );
      }),
    );
  }
}
