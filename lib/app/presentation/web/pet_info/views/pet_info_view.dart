import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawnco/app/core/constants/assets_path.dart';
import 'package:pawnco/app/core/themes/theme_helper.dart';
import 'package:pawnco/app/core/utils/gap_helper.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';
import 'package:pawnco/app/presentation/widgets/appbar.dart';
import 'package:pawnco/app/presentation/widgets/loading_overlay.dart';
import 'package:pawnco/app/presentation/widgets/small_button.dart';
import 'package:pawnco/app/presentation/widgets/textfield.dart';

import '../controllers/pet_info_controller.dart';

class PetInfoView extends GetView<PetInfoController> {
  const PetInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                PawAppBar(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: MediaQuery.of(context).size.width * 0.3,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppThemeHelper.color.surfaceDim,
                        ),
                      ),
                      padding: EdgeInsets.all(40),
                      child: Obx(() {
                        if (controller.fetchState == FetchState.loading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Form(
                          key: controller.key,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: AppThemeHelper.color.textPrimary,
                                      size: 30,
                                    ),
                                  ),
                                  Obx(() {
                                    return Column(
                                      children: [
                                        Text(
                                          controller.isEdit
                                              ? 'Edit Pet'
                                              : 'Add New Pet',
                                          style: AppThemeHelper.font.title(),
                                          textAlign: TextAlign.center,
                                        ),
                                        Gap.v8,
                                        Text(
                                          controller.isEdit
                                              ? 'Update the details for your beloved pet.'
                                              : 'Enter the details for your new furry, scaly, or feathered friend!',
                                          style: AppThemeHelper.font
                                              .description(
                                                color:
                                                    AppThemeHelper
                                                        .color
                                                        .surfaceDim,
                                              ),
                                        ),
                                      ],
                                    );
                                  }),
                                  SizedBox(),
                                ],
                              ),
                              Gap.h(40),
                              Textfield(
                                title: 'Pet Name',
                                controller: controller.name,
                                validators: (val) {
                                  if (val.isEmpty) {
                                    return 'Pet Name is Required!';
                                  }
                                },
                              ),
                              Gap.v20,
                              Textfield(
                                title: 'Category',
                                controller: controller.category,
                                validators: (val) {
                                  if (val.isEmpty) {
                                    return 'Category is Required!';
                                  }
                                },
                              ),
                              Gap.v20,
                              Textfield(
                                title: 'Tags',
                                controller: controller.tags,
                              ),
                              Gap.v20,
                              Textfield(
                                title: 'Photo Urls',
                                controller: controller.photoCtrl,
                                onChanged: (val) {
                                  controller.photos = val;
                                  debugPrint('photos : ${controller.photos}');
                                },
                              ),
                              Gap.v20,
                              Text(
                                'Photo Preview',
                                style: AppThemeHelper.font.title2(),
                              ),
                              Gap.v10,
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color:
                                        AppThemeHelper
                                            .color
                                            .surfaceDim, // background color
                                  ),
                                  clipBehavior:
                                      Clip.antiAlias, // keeps the rounded corners
                                  child: Obx(
                                    () => SizedBox.expand(
                                      child: CachedNetworkImage(
                                        imageUrl: controller.photos,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (_, __) => const SizedBox.expand(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
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
                              ),
                              Gap.v20,
                              SmallButton.primary(
                                label: 'Save',
                                color: AppThemeHelper.color.primary,
                                onTap: () async {
                                  if (controller.key.currentState!.validate()) {
                                    if (controller.isEdit) {
                                      await controller.editPet();
                                    } else {
                                      await controller.addPet();
                                    }
                                    Get.back(result: true);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            if (controller.fetchState == FetchState.fetching) LoadingOverlay(),
          ],
        ),
      );
    });
  }
}
