import 'package:get/get.dart';
import 'package:pawnco/app/data/repositories_impl/pets_repository_impl.dart';
import 'package:pawnco/app/data/sources/pets_remote_source.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/add_pet_usecase.dart';
import 'package:pawnco/app/domain/usecases/edit_pet_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pet_detail_usecase.dart';

import '../controllers/pet_info_controller.dart';

class PetInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PetsRemoteSource(Get.find()));
    Get.lazyPut<PetRepository>(() => PetsRepositoryImpl(Get.find()));

    // Domain
    Get.lazyPut(() => GetPetDetailUsecase(Get.find()));
    Get.lazyPut(() => AddPetUsecase(Get.find()));
    Get.lazyPut(() => EditPetUsecase(Get.find()));

    Get.lazyPut<PetInfoController>(
      () => PetInfoController(Get.find(), Get.find(), Get.find()),
    );
  }
}
