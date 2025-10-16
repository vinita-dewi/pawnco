import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/usecases/add_pet_usecase.dart';
import 'package:pawnco/app/domain/usecases/edit_pet_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pet_detail_usecase.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';

class PetInfoController extends GetxController {
  final GetPetDetailUsecase getPetDetailUseCase;
  final AddPetUsecase addPetUsecase;
  final EditPetUsecase editPetUsecase;

  PetInfoController(
    this.getPetDetailUseCase,
    this.addPetUsecase,
    this.editPetUsecase,
  );

  final RxBool _isEdit = false.obs;
  bool get isEdit => _isEdit.value;

  final Rx<FetchState> _fetchState = FetchState.none.obs;
  FetchState get fetchState => _fetchState.value;

  final Rxn<Pets> _pet = Rxn<Pets>();
  Pets? get pet => _pet.value;

  final TextEditingController name = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController tags = TextEditingController();
  final RxString _photos = ''.obs;
  String get photos => _photos.value;

  set photos(String val) => _photos.value = val;

  final GlobalKey<FormState> key = GlobalKey<FormState>();

  final logger = Logger();
  @override
  void onInit() {
    super.onInit();
    _isEdit.value = Get.arguments != null;
    if (Get.arguments != null) {
      String id = Get.arguments;
      loadPetDetail(id);
      fillTextController();
    }
  }

  fillTextController() {
    name.text = pet?.name ?? '';
    category.text = pet?.category?.name ?? '';
    tags.text = (pet?.tags ?? []).join(',');
    _photos.value = (pet?.photos ?? []).isEmpty ? '' : pet?.photos?.first ?? '';
  }

  Future<void> loadPetDetail(String id) async {
    try {
      _fetchState.value = FetchState.loading;

      _pet.value = await getPetDetailUseCase(id);

      logger.d('result get pet : ${_pet.value}');
    } catch (e, s) {
      logger.e('stack get pet : $e');
    } finally {
      _fetchState.value = FetchState.none;
    }
  }

  Future<void> addPet() async {
    try {
      _fetchState.value = FetchState.fetching;
      Random random = Random();

      var json = {
        'id': random.nextInt(100),
        'name': name.text,
        'category': {'id': random.nextInt(100), 'name': category.text},
        'tags':
            tags.text
                .split(',')
                .map((e) => {'id': random.nextInt(100), 'name': e})
                .toList(),
        'photoUrls': [photos],
        'status': 'available',
      };
      _pet.value = await addPetUsecase(json);
    } catch (e) {
      logger.e('error add pet : $e');
    } finally {
      _fetchState.value = FetchState.none;
    }
  }
}
