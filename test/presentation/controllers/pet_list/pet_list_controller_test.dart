import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/entities/tags.dart' as tag;
import 'package:pawnco/app/domain/usecases/get_pet_by_tag_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pet_detail_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pets_usecase.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';
import 'package:pawnco/app/presentation/mobile/pet_list/controllers/pet_list_controller.dart';

// Generate "nice" mocks so unstubbed calls won't crash tests.
@GenerateNiceMocks([
  MockSpec<GetPetsUseCase>(),
  MockSpec<GetPetDetailUsecase>(),
  MockSpec<GetPetByTagUseCase>(),
  MockSpec<Pets>(),
  MockSpec<tag.Tags>(),
])
import 'pet_list_controller_test.mocks.dart';

void main() {
  late MockGetPetsUseCase mockGetPets;
  late MockGetPetDetailUsecase mockGetPetDetail;
  late MockGetPetByTagUseCase mockGetByTag;
  late PetListController controller;

  setUp(() {
    Get.testMode = true;
    mockGetPets = MockGetPetsUseCase();
    mockGetPetDetail = MockGetPetDetailUsecase();
    mockGetByTag = MockGetPetByTagUseCase();

    controller = PetListController(mockGetPets, mockGetPetDetail, mockGetByTag);
  });

  Future<void> pumpMicro() async {
    await Future.delayed(const Duration(milliseconds: 1));
  }

  group('PetListController', () {
    test(
      'init() calls loadPets then initTags; fetchState ends as none; pets & tags filled',
      () async {
        final pet1 = MockPets();
        final pet2 = MockPets();
        final tag1 = MockTags();
        final tag2 = MockTags();

        when(pet1.tags).thenReturn([tag1, tag2]);
        when(pet2.tags).thenReturn(<tag.Tags>[]);

        when(mockGetPets()).thenAnswer((_) async => [pet1, pet2]);

        await controller.init();

        expect(controller.fetchState, FetchState.none);
        expect(controller.pets.length, 2);
        // initTags should collect tag1 and tag2 (duplicates allowed by current code)
        expect(controller.tags.length, 2);
        verify(mockGetPets()).called(1);
        verifyNoMoreInteractions(mockGetPets);
      },
    );

    test('onReady() triggers async init()', () async {
      final pet = MockPets();
      when(pet.tags).thenReturn(<tag.Tags>[]);
      when(mockGetPets()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 1));
        return [pet];
      });

      controller.onReady();
      expect(
        controller.fetchState,
        anyOf(FetchState.loading, FetchState.fetching, FetchState.none),
      );

      await pumpMicro();

      expect(controller.fetchState, FetchState.none);
      expect(controller.pets.length, 1);
      verify(mockGetPets()).called(1);
    });

    test('loadPets sets state fetching → none and assigns pets', () async {
      final pet = MockPets();
      when(pet.tags).thenReturn(<tag.Tags>[]);
      when(mockGetPets()).thenAnswer((_) async => [pet]);

      final f = controller.loadPets();

      expect(controller.fetchState, FetchState.fetching);

      await f;

      expect(controller.fetchState, FetchState.none);
      expect(controller.pets.length, 1);
      verify(mockGetPets()).called(1);
    });

    test('loadPets ends with state none when usecase throws', () async {
      when(mockGetPets()).thenThrow(Exception('boom'));

      await controller.loadPets();

      expect(controller.fetchState, FetchState.none);
      expect(controller.pets.length, 0);
      verify(mockGetPets()).called(1);
    });

    test('initTags aggregates tags from current pets list', () async {
      final petA = MockPets();
      final petB = MockPets();
      final t1 = MockTags();
      final t2 = MockTags();
      final t3 = MockTags();

      when(petA.tags).thenReturn([t1, t2]);
      when(petB.tags).thenReturn([t3]);

      controller.pets
        ..clear()
        ..addAll([petA, petB]);

      controller.initTags();

      expect(controller.tags.length, 3);
      expect(controller.tags[0], same(t1));
      expect(controller.tags[1], same(t2));
      expect(controller.tags[2], same(t3));
    });

    test(
      'loadPetsByTag uses selectedTags and updates pets; ends as none',
      () async {
        final filteredPet = MockPets();
        when(filteredPet.tags).thenReturn(<tag.Tags>[]);
        when(mockGetByTag(any)).thenAnswer((invocation) async {
          final arg = invocation.positionalArguments.first as List<String>;
          expect(arg, ['cute', 'small']); // assert the exact tags passed
          return [filteredPet];
        });

        controller.selectedTags.assignAll(['cute', 'small']);

        final f = controller.loadPetsByTag();

        expect(controller.fetchState, FetchState.fetching);

        await f;

        expect(controller.fetchState, FetchState.none);
        expect(controller.pets.length, 1);

        final captured =
            verify(mockGetByTag(captureAny)).captured.single as List<String>;
        expect(captured, ['cute', 'small']);
      },
    );

    test('loadPetsByTag ends with state none on error', () async {
      controller.selectedTags.assignAll(['x']);
      when(mockGetByTag(any)).thenThrow(Exception('network'));

      await controller.loadPetsByTag();

      expect(controller.fetchState, FetchState.none);

      expect(controller.pets, isEmpty);
      verify(mockGetByTag(any)).called(1);
    });
  });
}
