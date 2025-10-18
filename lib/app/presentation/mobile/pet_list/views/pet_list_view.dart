import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawnco/app/core/constants/assets_path.dart';
import 'package:pawnco/app/core/utils/gap_helper.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';
import 'package:pawnco/app/presentation/widgets/appbar.dart';
import 'package:pawnco/app/presentation/widgets/small_button.dart';
import 'package:pawnco/app/presentation/widgets/tag_list.dart';
import 'package:pawnco/app/presentation/widgets/tag_wrap.dart';
import 'package:pawnco/app/routes/app_pages.dart';

import '../../../../core/themes/theme_helper.dart';
import '../controllers/pet_list_controller.dart';

class PetListView extends GetView<PetListController> {
  const PetListView({super.key});

  _showPetDetailBottomsheet(Pets pet) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
          color: AppThemeHelper.color.background,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.close, size: 24),
              ),
            ),
            Gap.v20,
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(Get.context!).size.height * 0.2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppThemeHelper.color.surfaceDim, // background color
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox.expand(
                child: CachedNetworkImage(
                  imageUrl:
                      (pet.photos ?? []).isEmpty ? '' : pet.photos?.first ?? '',
                  fit: BoxFit.cover,
                  placeholder:
                      (_, __) => const SizedBox.expand(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (_, __, ___) => SizedBox.expand(
                        child: Center(
                          child: Image.asset(AssetsPath.empty, height: 50),
                        ),
                      ),
                ),
              ),
            ),
            Gap.v16,
            Text(
              pet.name!,
              style: AppThemeHelper.font.title2(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Gap.v12,
            Text(
              pet.category?.name ?? '',
              style: AppThemeHelper.font.body(
                color: AppThemeHelper.color.surfaceDim,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Gap.v12,
            TagWrap(tags: pet.tags ?? []),
            Gap.v20,
            SmallButton.primary(
              label: 'Adopt',
              color: AppThemeHelper.color.primary,
              onTap: () {
                Get.back();
                Get.toNamed(Routes.ORDER, arguments: {'pets': pet});
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildPetGridView() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: controller.pets.length,
        itemBuilder: (context, idx) {
          Pets pet = controller.pets[idx];
          return InkWell(
            onTap: () {
              _showPetDetailBottomsheet(pet);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    constraints: BoxConstraints(),
                    decoration: BoxDecoration(
                      color: AppThemeHelper.color.surfaceDim,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      ),
                      border: Border.all(
                        color: AppThemeHelper.color.surfaceDim,
                      ),
                    ),
                    clipBehavior:
                        Clip.antiAlias, // clip child to the rounded top corners
                    child:
                        (pet.photos == null || pet.photos!.isEmpty)
                            ? Center(
                              child: Image.asset(AssetsPath.empty, height: 50),
                            )
                            : SizedBox.expand(
                              // force the image to fill the container
                              child: CachedNetworkImage(
                                // rebuild when URL changes
                                imageUrl:
                                    (pet.photos ?? []).isEmpty
                                        ? ''
                                        : pet.photos?.first ?? '',
                                fit: BoxFit.cover,
                                placeholder:
                                    (_, __) => const SizedBox.expand(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                errorWidget:
                                    (_, __, ___) => SizedBox.expand(
                                      child: Center(
                                        child: Image.asset(
                                          AssetsPath.empty,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      border: Border.all(
                        color: AppThemeHelper.color.surfaceDim,
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name ?? '',
                          style: AppThemeHelper.font.title2(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        Gap.v8,
                        Text(
                          pet.category?.name ?? '-',
                          style: AppThemeHelper.font.description(
                            color: AppThemeHelper.color.surfaceDim,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap.v20,
          PawAppBar(),
          Gap.v20,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Available for Adoption',
              style: AppThemeHelper.font.title(),
            ),
          ),
          Gap.v20,
          TagList(),
          Expanded(
            child: Obx(
              () =>
                  controller.fetchState == FetchState.loading ||
                          controller.fetchState == FetchState.fetching
                      ? Center(child: CircularProgressIndicator())
                      : _buildPetGridView(),
            ),
          ),
        ],
      ),
    );
  }
}
