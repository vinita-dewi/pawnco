import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/usecases/delete_pet_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pets_usecase.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';
import 'package:pawnco/app/presentation/web/home/controllers/home_controller.dart';

@GenerateNiceMocks([
  MockSpec<GetPetsUseCase>(),
  MockSpec<DeletePetUsecase>(),
  MockSpec<Pets>(),
])
import 'home_controller_test.mocks.dart';

void main() {
  late MockGetPetsUseCase mockGetPetsUseCase;
  late MockDeletePetUsecase mockDeletePetUsecase;
  late HomeController controller;

  setUp(() {
    Get.testMode = true;
    mockGetPetsUseCase = MockGetPetsUseCase();
    mockDeletePetUsecase = MockDeletePetUsecase();
    controller = HomeController(mockGetPetsUseCase, mockDeletePetUsecase);
  });

  group('HomeController', () {
    test('init() triggers loadPets and fills pets list', () async {
      final pet1 = MockPets();
      final pet2 = MockPets();
      when(mockGetPetsUseCase()).thenAnswer((_) async => [pet1, pet2]);

      await controller.init(); // awaitable now

      expect(controller.fetchState, FetchState.none);
      expect(controller.pets.length, 2);
      verify(mockGetPetsUseCase()).called(1);
      verifyNoMoreInteractions(mockGetPetsUseCase);
    });

    test('onReady() fires init() (async) and eventually fills pets', () async {
      final pet = MockPets();
      when(mockGetPetsUseCase()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 1));
        return [pet];
      });

      controller.onReady(); // fire-and-forget call to init()
      await Future.delayed(const Duration(milliseconds: 5));

      expect(controller.fetchState, FetchState.none);
      expect(controller.pets.length, 1);
      verify(mockGetPetsUseCase()).called(1);
    });

    test('loadPets sets state to loading then none and assigns pets', () async {
      final pet = MockPets();
      when(mockGetPetsUseCase()).thenAnswer((_) async => [pet]);

      final future = controller.loadPets();

      expect(controller.fetchState, FetchState.loading);

      await future;

      expect(controller.fetchState, FetchState.none);
      expect(controller.pets.length, 1);
      verify(mockGetPetsUseCase()).called(1);
    });

    test('loadPets returns state none even when usecase throws', () async {
      when(mockGetPetsUseCase()).thenThrow(Exception('boom'));

      await controller.loadPets();

      expect(controller.fetchState, FetchState.none);
      expect(controller.pets.length, 0);
      verify(mockGetPetsUseCase()).called(1);
    });

    test(
      'deletePet calls DeletePetUsecase and sets fetching -> none',
      () async {
        const id = '123';
        when(mockDeletePetUsecase(id)).thenAnswer((_) async {});

        final future = controller.deletePet(id);

        expect(controller.fetchState, FetchState.fetching);

        await future;

        // Assert final state and interaction
        expect(controller.fetchState, FetchState.none);
        verify(mockDeletePetUsecase(id)).called(1);
        verifyNoMoreInteractions(mockDeletePetUsecase);
      },
    );

    test('deletePet ends with state none even when usecase throws', () async {
      const id = '999';
      when(mockDeletePetUsecase(id)).thenThrow(Exception('network'));

      await controller.deletePet(id);

      expect(controller.fetchState, FetchState.none);
      verify(mockDeletePetUsecase(id)).called(1);
    });
  });
}
