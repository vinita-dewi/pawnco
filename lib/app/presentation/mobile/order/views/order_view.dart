import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawnco/app/core/constants/assets_path.dart';
import 'package:pawnco/app/core/themes/theme_helper.dart';
import 'package:pawnco/app/core/utils/convert_date.dart';
import 'package:pawnco/app/core/utils/gap_helper.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';
import 'package:pawnco/app/presentation/widgets/tag_wrap.dart';

import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  Widget _buildOrderInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppThemeHelper.color.surfaceDim, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Information', style: AppThemeHelper.font.body()),
          Container(
            width: double.infinity,
            height: 1,
            color: AppThemeHelper.color.surfaceDim,
            margin: EdgeInsets.symmetric(vertical: 8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text('Status', style: AppThemeHelper.font.description()),
              Text(
                controller.order?.status ?? '',
                style: AppThemeHelper.font.description(
                  color: AppThemeHelper.color.surfaceDim,
                ),
              ),
            ],
          ),
          Gap.v4,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order Date', style: AppThemeHelper.font.description()),
              Text(
                Date.convert(
                  DateTime.tryParse(controller.order?.shipDate ?? '') ??
                      DateTime.now(),
                ),
                style: AppThemeHelper.font.description(
                  color: AppThemeHelper.color.surfaceDim,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetInfo() {
    Pets? pet = controller.pet;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppThemeHelper.color.surfaceDim, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              controller.expanded = !controller.expanded;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pet Information', style: AppThemeHelper.font.body()),
                Obx(
                  () => Icon(
                    controller.expanded
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          if (controller.expanded) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: AppThemeHelper.color.surfaceDim,
              margin: EdgeInsets.symmetric(vertical: 8),
            ),
            Gap.v8,
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(Get.context!).size.height * 0.2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppThemeHelper.color.surfaceDim, // background color
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox.expand(
                child: CachedNetworkImage(
                  imageUrl:
                      (pet?.photos ?? []).isEmpty
                          ? ''
                          : pet?.photos?.first ?? '',
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
            Gap.v8,
            Text(pet?.name ?? '', style: AppThemeHelper.font.title2()),
            Gap.v4,
            Text(
              pet?.category?.name ?? '',
              style: AppThemeHelper.font.description(
                color: AppThemeHelper.color.surfaceDim,
              ),
            ),
            Gap.v8,
            TagWrap(tags: pet?.tags ?? []),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail', style: AppThemeHelper.font.title2()),
      ),
      body: Obx(
        () =>
            controller.fetchState == FetchState.loading
                ? Center(child: CircularProgressIndicator())
                : Container(
                  padding: EdgeInsets.all(40),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          controller.order?.isComplete == true
                              ? Icons.check_circle
                              : Icons.cancel,
                          color:
                              controller.order?.isComplete == true
                                  ? AppThemeHelper.color.primary
                                  : AppThemeHelper.color.warning,

                          size: 70,
                        ),
                        Gap.v20,
                        Text(
                          controller.order?.isComplete == true
                              ? 'Order Completed'
                              : 'Order Failed',
                          style: AppThemeHelper.font.title(),
                          textAlign: TextAlign.center,
                        ),
                        Gap.v12,
                        Text(
                          controller.order?.isComplete == true
                              ? 'Yay! You are welcoming a new furry friend!'
                              : 'Oh No! You\'re order failed. Please try again later',
                          style: AppThemeHelper.font.body(
                            color: AppThemeHelper.color.surfaceDim,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gap.v20,
                        _buildOrderInfo(),
                        Gap.v20,
                        _buildPetInfo(),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
