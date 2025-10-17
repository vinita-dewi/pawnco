import 'dart:math';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pawnco/app/domain/entities/order.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/usecases/order_pet_usecase.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';

class OrderController extends GetxController {
  final OrderPetUseCase orderPetUseCase;

  OrderController(this.orderPetUseCase);

  final Rx<FetchState> _fetchState = FetchState.loading.obs;
  FetchState get fetchState => _fetchState.value;

  var logger = Logger();

  final Rxn<Pets> _pet = Rxn<Pets>();
  Pets? get pet => _pet.value;

  final Rxn<Order> _order = Rxn<Order>();
  Order? get order => _order.value;

  final RxBool _expanded = false.obs;
  bool get expanded => _expanded.value;

  set expanded(bool x) => _expanded.value = x;

  @override
  void onReady() {
    super.onReady();
    if (Get.arguments?['pets'] is Pets) {
      _pet.value = Get.arguments['pets'];
      adoptPet();
    }
  }

  Future<void> adoptPet() async {
    try {
      List<String> status = ['Approved', 'Pending', 'In Progress'];
      List<bool> complete = [true, false];
      _fetchState.value = FetchState.loading;
      var rnd = Random();
      var json = {
        "id": rnd.nextInt(100),
        "petId": _pet.value!.id,
        "quantity": 1,
        "shipDate": DateTime.now().toIso8601String(),
        "status": status[rnd.nextInt(status.length)],
        "complete": complete[rnd.nextInt(complete.length)],
      };
      _order.value = await orderPetUseCase(json);

      logger.i('result order : ${_order}');
    } catch (e) {
      logger.e('error adopt : $e');
    } finally {
      _fetchState.value = FetchState.none;
    }
  }
}
