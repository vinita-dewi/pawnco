import 'package:get/get.dart';
import 'package:pawnco/app/core/network/dio_client.dart';
import 'package:pawnco/app/data/repositories_impl/pets_repository_impl.dart';
import 'package:pawnco/app/data/sources/pets_remote_source.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/get_pet_by_tag_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pet_detail_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pets_usecase.dart';

import '../controllers/pet_list_controller.dart';

class PetListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient.create(), permanent: true);

    // Data
    Get.lazyPut(() => PetsRemoteSource(Get.find()));
    Get.lazyPut<PetRepository>(() => PetsRepositoryImpl(Get.find()));

    // Domain
    Get.lazyPut(() => GetPetsUseCase(Get.find()));
    Get.lazyPut(() => GetPetDetailUsecase(Get.find()));
    Get.lazyPut(() => GetPetByTagUseCase(Get.find()));

    // Controller
    Get.lazyPut<PetListController>(
      () => PetListController(Get.find(), Get.find(), Get.find()),
    );
  }
}
