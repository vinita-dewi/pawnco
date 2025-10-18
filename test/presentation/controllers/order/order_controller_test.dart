import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/entities/order.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/usecases/order_pet_usecase.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';
import 'package:pawnco/app/presentation/mobile/order/controllers/order_controller.dart';

@GenerateNiceMocks([
  MockSpec<OrderPetUseCase>(),
  MockSpec<Pets>(),
  MockSpec<Order>(),
])
import 'order_controller_test.mocks.dart';

void main() {
  late MockOrderPetUseCase mockOrderUseCase;
  late MockPets mockPets;
  late MockOrder mockOrder;
  late OrderController controller;

  setUp(() {
    Get.testMode = true;
    mockOrderUseCase = MockOrderPetUseCase();
    mockPets = MockPets();
    mockOrder = MockOrder();
    controller = OrderController(mockOrderUseCase);
  });

  Future<void> _pumpHarness(WidgetTester tester, {Object? arguments}) async {
    await tester.pumpWidget(GetMaterialApp(home: const SizedBox.shrink()));
    Get.to(() => const SizedBox.shrink(), arguments: arguments);
    await tester.pump();
  }

  group('OrderController', () {
    testWidgets(
      'onReady reads arguments, sets pet, calls adoptPet, and assigns order',
      (WidgetTester tester) async {
        when(mockPets.id).thenReturn('123');
        when(mockOrderUseCase(any)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 1));
          return mockOrder;
        });

        await _pumpHarness(tester, arguments: {'pets': mockPets});

        controller.onReady();

        expect(controller.fetchState, FetchState.loading);

        await tester.pump(const Duration(milliseconds: 5));

        expect(controller.fetchState, FetchState.none);
        expect(controller.order, same(mockOrder));

        final captured =
            verify(mockOrderUseCase(captureAny)).captured.single
                as Map<String, dynamic>;
        expect(captured['petId'].toString(), '123');
        expect(captured['quantity'], 1);
        expect(captured.containsKey('status'), isTrue);
        expect(captured.containsKey('complete'), isTrue);
        expect(captured.containsKey('shipDate'), isTrue);
      },
    );

    testWidgets(
      'adoptPet sets loading → none and assigns order (when pet is preset)',
      (WidgetTester tester) async {
        when(mockPets.id).thenReturn('777');
        when(mockOrderUseCase(any)).thenAnswer((_) async => mockOrder);

        await _pumpHarness(tester, arguments: {'pets': mockPets});

        controller.onReady();
        await tester.pump();

        await tester.pump(const Duration(milliseconds: 5));

        expect(controller.fetchState, FetchState.none);
        expect(controller.order, same(mockOrder));
        verify(mockOrderUseCase(any)).called(1);
      },
    );

    testWidgets('adoptPet ends with state none even when usecase throws', (
      WidgetTester tester,
    ) async {
      when(mockPets.id).thenReturn('555');
      when(mockOrderUseCase(any)).thenThrow(Exception('boom'));

      await _pumpHarness(tester, arguments: {'pets': mockPets});

      controller.onReady();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 5));

      expect(controller.fetchState, FetchState.none);
      expect(controller.order, isNull);
      verify(mockOrderUseCase(any)).called(1);
    });

    testWidgets('pet getter returns the pet passed in arguments', (
      tester,
    ) async {
      when(mockPets.id).thenReturn('42');
      when(mockOrderUseCase(any)).thenAnswer((_) async => mockOrder);

      await _pumpHarness(tester, arguments: {'pets': mockPets});

      controller.onReady();
      await tester.pump(); // start adopt
      await tester.pump(const Duration(milliseconds: 5)); // finish adopt

      expect(controller.pet, same(mockPets));
    });

    test('expanded getter defaults to false', () {
      expect(controller.expanded, isFalse);
    });

    test('expanded setter updates the value', () {
      controller.expanded = true;
      expect(controller.expanded, isTrue);
      controller.expanded = false;
      expect(controller.expanded, isFalse);
    });
  });
}
