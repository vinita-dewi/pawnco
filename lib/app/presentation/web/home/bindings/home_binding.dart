import 'package:get/get.dart';
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
    Get.put(DioClient.create(), permanent: true);

    Get.lazyPut(() => PetsRemoteSource(Get.find()));
    Get.lazyPut<PetRepository>(() => PetsRepositoryImpl(Get.find()));

    Get.lazyPut(() => GetPetsUseCase(Get.find()));
    Get.lazyPut(() => DeletePetUsecase(Get.find()));

    Get.lazyPut(() => HomeController(Get.find(), Get.find()));
  }
}
