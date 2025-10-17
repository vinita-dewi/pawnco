import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../presentation/mobile/order/bindings/order_binding.dart';
import '../presentation/mobile/order/views/order_view.dart';
import '../presentation/mobile/pet_list/bindings/pet_list_binding.dart';
import '../presentation/mobile/pet_list/views/pet_list_view.dart';
import '../presentation/web/home/bindings/home_binding.dart';
import '../presentation/web/home/views/home_view.dart';
import '../presentation/web/pet_info/bindings/pet_info_binding.dart';
import '../presentation/web/pet_info/views/pet_info_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = kIsWeb ? Routes.HOME : Routes.PET_LIST;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PET_INFO,
      page: () => const PetInfoView(),
      binding: PetInfoBinding(),
    ),
    GetPage(
      name: _Paths.PET_LIST,
      page: () => const PetListView(),
      binding: PetListBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
  ];
}
