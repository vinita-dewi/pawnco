import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/usecases/delete_pet_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pets_usecase.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';

class HomeController extends GetxController {
  final GetPetsUseCase getPetsUseCase;

  final DeletePetUsecase deletePetUsecase;
  HomeController(this.getPetsUseCase, this.deletePetUsecase);

  final Rx<FetchState> _fetchState = FetchState.none.obs;
  FetchState get fetchState => _fetchState.value;

  var logger = Logger();

  final RxList<Pets> _pets = <Pets>[].obs;
  List<Pets> get pets => _pets.value;

  @override
  void onReady() {
    super.onReady();
    logger.d('LOAD PETS!!');
    init();
  }

  Future<void> init() async {
    await loadPets();
  }

  Future<void> loadPets() async {
    try {
      _fetchState.value = FetchState.loading;

      _pets.value = await getPetsUseCase();

      logger.d('result get pet : ${_pets.value}');

      _fetchState.value = FetchState.none;
    } catch (e, s) {
      logger.e('stack get pet : $e');
    } finally {
      _fetchState.value = FetchState.none;
    }
  }

  Future<void> deletePet(String id) async {
    try {
      _fetchState.value = FetchState.fetching;

      await deletePetUsecase(id);
    } catch (e, s) {
      logger.e('stack delete pet : $e');
    } finally {
      _fetchState.value = FetchState.none;
    }
  }
}
