import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawnco/app/core/constants/assets_path.dart';
import 'package:pawnco/app/core/utils/gap_helper.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';
import 'package:pawnco/app/presentation/widgets/appbar.dart';
import 'package:pawnco/app/presentation/widgets/tag_list.dart';

import '../../../../core/themes/theme_helper.dart';
import '../controllers/pet_list_controller.dart';

class PetListView extends GetView<PetListController> {
  const PetListView({super.key});

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
            onTap: () {},
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    controller.fetchState == FetchState.loading
                        ? Center(child: CircularProgressIndicator())
                        : _buildPetGridView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
