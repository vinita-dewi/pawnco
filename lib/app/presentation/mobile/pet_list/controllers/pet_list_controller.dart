import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/entities/tags.dart';
import 'package:pawnco/app/domain/usecases/get_pet_by_tag_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pet_detail_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pets_usecase.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';

class PetListController extends GetxController {
  final GetPetsUseCase getPetsUseCase;

  final GetPetDetailUsecase getPetDetailUseCase;

  final GetPetByTagUseCase getPetByTagUseCase;
  PetListController(
    this.getPetsUseCase,
    this.getPetDetailUseCase,
    this.getPetByTagUseCase,
  );

  final Rx<FetchState> _fetchState = FetchState.none.obs;
  FetchState get fetchState => _fetchState.value;

  var logger = Logger();

  final RxList<Pets> _pets = <Pets>[].obs;
  List<Pets> get pets => _pets.value;

  final RxList<Tags> _tags = <Tags>[].obs;
  List<Tags> get tags => _tags.value;

  final RxList<String> _selectedTags = <String>[].obs;
  RxList<String> get selectedTags => _selectedTags;

  @override
  void onReady() {
    super.onReady();
    logger.d('LOAD PETS!!');
    loadPets();
  }

  Future<void> loadPets() async {
    try {
      _fetchState.value = FetchState.loading;
      _tags.value = [];

      _pets.value = await getPetsUseCase();

      logger.d('result get pet : ${_pets.value}');

      for (var pet in _pets) {
        if ((pet.tags ?? []).isNotEmpty) {
          tags.addAll(pet.tags!);
        }
      }

      logger.d('tags : $_tags');

      _fetchState.value = FetchState.none;
    } catch (e, s) {
      logger.e('stack get pet : $e');
    } finally {
      _fetchState.value = FetchState.none;
    }
  }

  Future<void> loadPetsByTag() async {
    try {
      _fetchState.value = FetchState.loading;

      _pets.value = await getPetByTagUseCase(_selectedTags);

      logger.d('result get pet by tag: ${_pets}');

      _fetchState.value = FetchState.none;
    } catch (e, s) {
      logger.e('stack get pet : $e');
    } finally {
      _fetchState.value = FetchState.none;
    }
  }
}
