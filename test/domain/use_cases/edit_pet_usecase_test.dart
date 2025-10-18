import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/edit_pet_usecase.dart';

// Generate lenient mocks for repo and entity
@GenerateNiceMocks([MockSpec<PetRepository>(), MockSpec<Pets>()])
import 'edit_pet_usecase_test.mocks.dart';

void main() {
  late EditPetUsecase usecase;
  late MockPetRepository mockRepo;
  late MockPets mockPets;

  setUp(() {
    mockRepo = MockPetRepository();
    mockPets = MockPets();
    usecase = EditPetUsecase(mockRepo);
  });

  test(
    'calls repository.editPet with provided json and returns Pets',
    () async {
      final json = {
        'id': 123,
        'name': 'Buddy',
        'category': {'id': 1, 'name': 'Dogs'},
        'photoUrls': ['http://img/pet.png'],
        'tags': [
          {'id': 10, 'name': 'cute'},
        ],
        'status': 'available',
      };
      when(mockRepo.editPet(json)).thenAnswer((_) async => mockPets);

      final result = await usecase(json);

      expect(result, same(mockPets));
      verify(mockRepo.editPet(json)).called(1);
      verifyNoMoreInteractions(mockRepo);
    },
  );

  test('propagates repository errors', () async {
    final json = {'id': 999, 'name': 'Err'};
    when(mockRepo.editPet(json)).thenThrow(Exception('network'));

    await expectLater(() => usecase(json), throwsA(isA<Exception>()));
    verify(mockRepo.editPet(json)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
