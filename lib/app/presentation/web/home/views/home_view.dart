import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawnco/app/core/constants/assets_path.dart';
import 'package:pawnco/app/core/themes/theme_helper.dart';
import 'package:pawnco/app/core/utils/gap_helper.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';
import 'package:pawnco/app/presentation/widgets/appbar.dart';
import 'package:pawnco/app/presentation/widgets/loading_overlay.dart';
import 'package:pawnco/app/presentation/widgets/small_button.dart';
import 'package:pawnco/app/presentation/widgets/tag_wrap.dart';
import 'package:pawnco/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  _showDeleteDialog(String name, String id) {
    Get.dialog(
      Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(Get.context!).size.width * 0.3,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Confirm Delete', style: AppThemeHelper.font.title2()),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: AppThemeHelper.color.textPrimary,
                      ),
                    ),
                  ],
                ),
                Gap.v8,
                Text(
                  'Are you sure you want to delete $name ? This action cannot be undone',
                  style: AppThemeHelper.font.body(
                    color: AppThemeHelper.color.surfaceDim,
                  ),
                ),
                Gap.h(40),
                SmallButton.primary(
                  label: 'Yes, Delete',
                  color: AppThemeHelper.color.warning,
                  onTap: () async {
                    Get.back();
                    await controller.deletePet(id);
                    await controller.loadPets();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(Pets pet) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(Get.context!).size.width * 0.5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pet.name!, style: AppThemeHelper.font.title2()),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: AppThemeHelper.color.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  color: AppThemeHelper.color.surfaceDim,
                  height: 1,
                ),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          AppThemeHelper.color.surfaceDim, // background color
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox.expand(
                      child: CachedNetworkImage(
                        imageUrl:
                            (pet.photos ?? []).isEmpty
                                ? ''
                                : pet.photos?.first ?? '',
                        fit: BoxFit.cover,
                        placeholder:
                            (_, __) => const SizedBox.expand(
                              child: Center(child: CircularProgressIndicator()),
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
                Gap.v20,
                Text(
                  'Category',
                  style: AppThemeHelper.font.description(
                    color: AppThemeHelper.color.surfaceDim,
                  ),
                ),
                Gap.v4,
                Text(
                  pet.category?.name ?? '',
                  style: AppThemeHelper.font.body(),
                ),
                Gap.v10,
                TagWrap(tags: pet.tags ?? []),
                Gap.h(50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SmallButton.outlined(
                      label: 'Edit',
                      color: AppThemeHelper.color.primary,
                      icon: Icons.edit,
                      onTap: () async {
                        Get.back();

                        bool res = await Get.toNamed(
                          Routes.PET_INFO,
                          parameters: {'id': pet.id!},
                          arguments: {'pet': pet},
                        );
                        if (res) {
                          controller.loadPets();
                        }
                      },
                    ),
                    Gap.h8,
                    SmallButton.primary(
                      label: 'Delete',
                      icon: Icons.delete_outline,
                      color: AppThemeHelper.color.warning,
                      onTap: () async {
                        Get.back();
                        _showDeleteDialog(pet.name!, pet.id!);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetGridView() {
    return Padding(
      padding: EdgeInsets.all(60),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: controller.pets.length,
        itemBuilder: (context, idx) {
          Pets pet = controller.pets[idx];
          return InkWell(
            onTap: () => _showDetailDialog(pet),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(Get.context!).size.height * 0.2,
                  ),
                  decoration: BoxDecoration(
                    color: AppThemeHelper.color.surfaceDim,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                    border: Border.all(color: AppThemeHelper.color.surfaceDim),
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
                Expanded(
                  child: Container(
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        Gap.v8,
                        Text(
                          pet.category?.name ?? '-',
                          style: AppThemeHelper.font.description(
                            color: AppThemeHelper.color.surfaceDim,
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SmallButton.outlined(
                              label: 'Edit',
                              color: AppThemeHelper.color.primary,
                              onTap: () async {
                                bool res = await Get.toNamed(
                                  Routes.PET_INFO,
                                  parameters: {'id': pet.id!},
                                  arguments: {'pet': pet},
                                );
                                if (res) {
                                  controller.loadPets();
                                }
                              },
                            ),
                            Gap.h8,
                            SmallButton.primary(
                              label: 'Delete',
                              color: AppThemeHelper.color.warning,
                              onTap:
                                  () => _showDeleteDialog(
                                    pet.name ?? '',
                                    pet.id!,
                                  ),
                            ),
                          ],
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
      body: Stack(
        children: [
          Column(
            children: [
              PawAppBar(),
              Expanded(
                child: Obx(
                  () =>
                      controller.fetchState == FetchState.loading
                          ? Center(child: CircularProgressIndicator())
                          : _buildPetGridView(),
                ),
              ),
            ],
          ),
          if (controller.fetchState == FetchState.fetching) LoadingOverlay(),
        ],
      ),
    );
  }
}
