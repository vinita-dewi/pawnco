import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/entities/order.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';
import 'package:pawnco/app/domain/usecases/order_pet_usecase.dart';

@GenerateNiceMocks([MockSpec<PetRepository>(), MockSpec<Order>()])
import 'order_pet_usecase_test.mocks.dart';

void main() {
  late OrderPetUseCase usecase;
  late MockPetRepository mockRepo;
  late MockOrder mockOrder;

  setUp(() {
    mockRepo = MockPetRepository();
    mockOrder = MockOrder();
    usecase = OrderPetUseCase(mockRepo);
  });

  test('returns Order from repository', () async {
    final json = {'id': 1, 'petId': 2};
    when(mockRepo.postPetOrder(json)).thenAnswer((_) async => mockOrder);
    final result = await usecase(json);
    expect(result, same(mockOrder));
    verify(mockRepo.postPetOrder(json)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('propagates errors', () async {
    final json = {'id': 9};
    when(mockRepo.postPetOrder(json)).thenThrow(Exception('e'));
    await expectLater(() => usecase(json), throwsA(isA<Exception>()));
    verify(mockRepo.postPetOrder(json)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
