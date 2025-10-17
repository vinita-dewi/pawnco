import 'package:get/get.dart';
import 'package:pawnco/app/data/repositories_impl/pets_repository_impl.dart';
import 'package:pawnco/app/data/sources/pets_remote_source.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/order_pet_usecase.dart';

import '../controllers/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PetsRemoteSource(Get.find()));
    Get.lazyPut<PetRepository>(() => PetsRepositoryImpl(Get.find()));

    // Domain
    Get.lazyPut(() => OrderPetUseCase(Get.find()));
    Get.lazyPut<OrderController>(() => OrderController(Get.find()));
  }
}
