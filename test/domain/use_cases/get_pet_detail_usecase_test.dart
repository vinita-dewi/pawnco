import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/get_pet_detail_usecase.dart';

@GenerateNiceMocks([MockSpec<PetRepository>(), MockSpec<Pets>()])
import 'get_pet_detail_usecase_test.mocks.dart';

void main() {
  late GetPetDetailUsecase usecase;
  late MockPetRepository mockRepo;
  late MockPets mockPets;

  setUp(() {
    mockRepo = MockPetRepository();
    mockPets = MockPets();
    usecase = GetPetDetailUsecase(mockRepo);
  });

  test('returns Pets from repository', () async {
    when(mockRepo.getPetDetail('10')).thenAnswer((_) async => mockPets);
    final result = await usecase('10');
    expect(result, same(mockPets));
    verify(mockRepo.getPetDetail('10')).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('propagates errors', () async {
    when(mockRepo.getPetDetail('x')).thenThrow(Exception('e'));
    await expectLater(() => usecase('x'), throwsA(isA<Exception>()));
    verify(mockRepo.getPetDetail('x')).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
