import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/delete_pet_usecase.dart';

@GenerateNiceMocks([MockSpec<PetRepository>()])
import 'delete_pet_usecase_test.mocks.dart';

void main() {
  late DeletePetUsecase usecase;
  late MockPetRepository mockRepo;

  setUp(() {
    mockRepo = MockPetRepository();
    usecase = DeletePetUsecase(mockRepo);
  });

  test('calls repository.deletePet with correct id and completes', () async {
    const id = '42';
    when(mockRepo.deletePet(id)).thenAnswer((_) async {});

    await expectLater(usecase(id), completes);

    verify(mockRepo.deletePet(id)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('propagates repository errors', () async {
    const id = '99';
    when(mockRepo.deletePet(id)).thenThrow(Exception('network error'));

    await expectLater(() => usecase(id), throwsA(isA<Exception>()));

    verify(mockRepo.deletePet(id)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
