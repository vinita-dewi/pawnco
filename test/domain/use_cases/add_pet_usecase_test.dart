import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/add_pet_usecase.dart';

// Generate nice mocks so unstubbed calls don't crash in tests.
@GenerateNiceMocks([MockSpec<PetRepository>(), MockSpec<Pets>()])
import 'add_pet_usecase_test.mocks.dart';

void main() {
  late AddPetUsecase usecase;
  late MockPetRepository mockRepo;
  late MockPets mockPets;

  setUp(() {
    mockRepo = MockPetRepository();
    mockPets = MockPets();
    usecase = AddPetUsecase(mockRepo);
  });

  test('calls repository.addPet with provided json and returns Pets', () async {
    // Arrange
    final json = {'name': 'Buddy', 'category': 'dog'};
    when(mockRepo.addPet(json)).thenAnswer((_) async => mockPets);

    // Act
    final result = await usecase(json);

    // Assert
    expect(result, same(mockPets)); // same instance returned
    verify(mockRepo.addPet(json)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('rethrows repository error', () async {
    // Arrange
    final json = {'name': 'Kitty', 'category': 'cat'};
    when(mockRepo.addPet(json)).thenThrow(Exception('network'));

    // Act & Assert
    expect(() => usecase(json), throwsA(isA<Exception>()));
    verify(mockRepo.addPet(json)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
