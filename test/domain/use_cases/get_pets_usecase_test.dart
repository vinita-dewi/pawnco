import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/get_pets_usecase.dart';

@GenerateNiceMocks([MockSpec<PetRepository>(), MockSpec<Pets>()])
import 'get_pets_usecase_test.mocks.dart';

void main() {
  late GetPetsUseCase usecase;
  late MockPetRepository mockRepo;

  setUp(() {
    mockRepo = MockPetRepository();
    usecase = GetPetsUseCase(mockRepo);
  });

  test('returns list of Pets from repository', () async {
    final p1 = MockPets();
    final p2 = MockPets();
    when(mockRepo.getPets()).thenAnswer((_) async => [p1, p2]);
    final result = await usecase();
    expect(result.length, 2);
    verify(mockRepo.getPets()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('propagates errors', () async {
    when(mockRepo.getPets()).thenThrow(Exception('e'));
    await expectLater(() => usecase(), throwsA(isA<Exception>()));
    verify(mockRepo.getPets()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
