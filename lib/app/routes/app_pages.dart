import 'package:get/get.dart';

import '../presentation/web/home/bindings/home_binding.dart';
import '../presentation/web/home/views/home_view.dart';
import '../presentation/web/pet_info/bindings/pet_info_binding.dart';
import '../presentation/web/pet_info/views/pet_info_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

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
  ];
}
