import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pawnco/app/core/network/dio_client.dart';
import 'package:pawnco/app/data/repositories_impl/pets_repository_impl.dart';
import 'package:pawnco/app/data/sources/pets_remote_source.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/delete_pet_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pets_usecase.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    try {
      Get.put(DioClient.create(), permanent: true);

      // Data
      Get.lazyPut(() => PetsRemoteSource(Get.find()));
      Get.lazyPut<PetRepository>(() => PetsRepositoryImpl(Get.find()));

      // Domain
      Get.lazyPut(() => GetPetsUseCase(Get.find()));
      Get.lazyPut(() => DeletePetUsecase(Get.find()));

      // Controller
      Get.lazyPut(() => HomeController(Get.find(), Get.find()));
    } catch (e) {
      Logger().e('error on binding :$e');
    }
    Logger().d('HOME BINDING CALLED!!');
  }
}
