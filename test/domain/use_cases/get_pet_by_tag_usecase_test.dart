import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/get_pet_by_tag_usecase.dart';

// Generate lenient mocks
@GenerateNiceMocks([MockSpec<PetRepository>(), MockSpec<Pets>()])
import 'get_pet_by_tag_usecase_test.mocks.dart';

void main() {
  late GetPetByTagUseCase usecase;
  late MockPetRepository mockRepo;

  setUp(() {
    mockRepo = MockPetRepository();
    usecase = GetPetByTagUseCase(mockRepo);
  });

  test(
    'calls repository.getPetsByTag with provided tags and returns list of Pets',
    () async {
      final tags = ['cute', 'small'];
      final pet1 = MockPets();
      final pet2 = MockPets();
      when(mockRepo.getPetsByTag(tags)).thenAnswer((_) async => [pet1, pet2]);

      final result = await usecase(tags);

      expect(result, isA<List<Pets>>());
      expect(result.length, 2);

      final captured =
          verify(mockRepo.getPetsByTag(captureAny)).captured.single
              as List<String>;
      expect(captured, tags);

      verifyNoMoreInteractions(mockRepo);
    },
  );

  test('propagates repository errors', () async {
    final tags = ['rare'];
    when(mockRepo.getPetsByTag(tags)).thenThrow(Exception('network'));

    await expectLater(() => usecase(tags), throwsA(isA<Exception>()));

    verify(mockRepo.getPetsByTag(tags)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
