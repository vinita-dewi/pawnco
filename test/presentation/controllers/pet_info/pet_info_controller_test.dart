import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/domain/entities/category.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/entities/tags.dart' as tag;
import 'package:pawnco/app/domain/usecases/add_pet_usecase.dart';
import 'package:pawnco/app/domain/usecases/edit_pet_usecase.dart';
import 'package:pawnco/app/domain/usecases/get_pet_detail_usecase.dart';
import 'package:pawnco/app/presentation/enums/fetch_state.dart';
import 'package:pawnco/app/presentation/web/pet_info/controllers/pet_info_controller.dart';

@GenerateNiceMocks([
  MockSpec<GetPetDetailUsecase>(),
  MockSpec<AddPetUsecase>(),
  MockSpec<EditPetUsecase>(),
  MockSpec<Pets>(),
  MockSpec<Category>(),
  MockSpec<tag.Tags>(),
])
import 'pet_info_controller_test.mocks.dart';

Future<void> _pumpGetHarness(
  WidgetTester tester, {
  Object? arguments,
  Map<String, String>? parameters,
}) async {
  await tester.pumpWidget(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SizedBox.shrink()),
        GetPage(name: '/pet', page: () => const SizedBox.shrink()),
      ],
    ),
  );
  Get.toNamed('/pet', arguments: arguments, parameters: parameters);
  await tester.pump();
}

void main() {
  late MockGetPetDetailUsecase mockGetDetail;
  late MockAddPetUsecase mockAdd;
  late MockEditPetUsecase mockEdit;
  late PetInfoController controller;

  setUp(() {
    Get.testMode = true;
    Get.reset();
    mockGetDetail = MockGetPetDetailUsecase();
    mockAdd = MockAddPetUsecase();
    mockEdit = MockEditPetUsecase();
    controller = PetInfoController(mockGetDetail, mockAdd, mockEdit);
  });

  group('PetInfoController', () {
    test('loadPetDetail sets loading -> none and assigns pet', () async {
      final mockPet = MockPets();
      when(mockGetDetail('123')).thenAnswer((_) async => mockPet);

      final fut = controller.loadPetDetail('123');
      expect(controller.fetchState, FetchState.loading);
      await fut;

      expect(controller.fetchState, FetchState.none);
      expect(controller.pet, same(mockPet));
      verify(mockGetDetail('123')).called(1);
      verifyNoMoreInteractions(mockGetDetail);
    });

    test('loadPetDetail ends with none on error', () async {
      when(mockGetDetail('x')).thenThrow(Exception('boom'));
      await controller.loadPetDetail('x');
      expect(controller.fetchState, FetchState.none);
      expect(controller.pet, isNull);
      verify(mockGetDetail('x')).called(1);
    });

    test('addPet builds JSON and calls EditPetUsecase', () async {
      controller.name.text = 'Buddy';
      controller.category.text = 'Dogs';
      controller.tags.text = 'cute,small';
      controller.photos = 'http://img/pet.png';

      final returnedPet = MockPets();
      when(mockEdit(any)).thenAnswer((_) async => returnedPet);

      final fut = controller.addPet();
      expect(controller.fetchState, FetchState.fetching);
      await fut;

      expect(controller.fetchState, FetchState.none);
      expect(controller.pet, same(returnedPet));

      final captured =
          verify(mockEdit(captureAny)).captured.single as Map<String, dynamic>;
      expect(captured['name'], 'Buddy');
      expect((captured['category'] as Map)['name'], 'Dogs');
      expect(captured['status'], 'available');
      final tags = captured['tags'] as List;
      expect(tags.length, 2);
      expect((tags[0] as Map)['name'], 'cute');
      expect((tags[1] as Map)['name'], 'small');
      final photos = captured['photoUrls'] as List;
      expect(photos.first, 'http://img/pet.png');
    });

    test('addPet ends with none when edit usecase throws', () async {
      controller.name.text = 'Oops';
      controller.category.text = 'Cats';
      controller.tags.text = 'fluffy';
      controller.photos = 'http://img/cat.png';
      when(mockEdit(any)).thenThrow(Exception('network'));
      await controller.addPet();
      expect(controller.fetchState, FetchState.none);
      expect(controller.pet, isNull);
      verify(mockEdit(any)).called(1);
    });

    test('editPet builds JSON with petId and calls EditPetUsecase', () async {
      controller.petId = '999';
      controller.name.text = 'Snow';
      controller.category.text = 'Cats';
      controller.tags.text = 'white,calm';
      controller.photos = 'http://img/snow.png';

      final returnedPet = MockPets();
      when(mockEdit(any)).thenAnswer((_) async => returnedPet);

      final fut = controller.editPet();
      expect(controller.fetchState, FetchState.fetching);
      await fut;

      expect(controller.fetchState, FetchState.none);
      expect(controller.pet, same(returnedPet));

      final captured =
          verify(mockEdit(captureAny)).captured.single as Map<String, dynamic>;
      expect(captured['id'].toString(), '999');
      expect(captured['name'], 'Snow');
      expect((captured['category'] as Map)['name'], 'Cats');
      expect(captured['status'], 'available');
      final tags = captured['tags'] as List;
      expect((tags[0] as Map)['name'], 'white');
      expect((tags[1] as Map)['name'], 'calm');
      final photos = captured['photoUrls'] as List;
      expect(photos.first, 'http://img/snow.png');
    });

    test('editPet ends with none on error', () async {
      controller.petId = '123';
      controller.name.text = 'Err';
      controller.category.text = 'Birds';
      controller.tags.text = 'blue';
      controller.photos = 'http://img/blue.png';
      when(mockEdit(any)).thenThrow(Exception('bad'));
      await controller.editPet();
      expect(controller.fetchState, FetchState.none);
      verify(mockEdit(any)).called(1);
    });

    testWidgets('init sets isEdit when arguments present and no parameters', (
      tester,
    ) async {
      await _pumpGetHarness(tester, arguments: {'foo': 'bar'});
      await controller.init();
      expect(controller.isEdit, isTrue);
    });

    testWidgets(
      'init with parameters id loads detail; if null, uses arguments.pet and fills fields',
      (tester) async {
        final fallbackPet = MockPets();
        final cat = MockCategory();
        final t1 = MockTags();
        final t2 = MockTags();

        when(fallbackPet.name).thenReturn('Fido');
        when(cat.name).thenReturn('Mammal');
        when(fallbackPet.category).thenReturn(cat);
        when(t1.name).thenReturn('cute');
        when(t2.name).thenReturn('smart');
        when(fallbackPet.tags).thenReturn([t1, t2]);
        when(fallbackPet.photos).thenReturn(['http://img/fido.png']);

        when(mockGetDetail('101')).thenThrow(Exception('fail-detail'));

        await _pumpGetHarness(
          tester,
          arguments: {'pet': fallbackPet},
          parameters: {'id': '101'},
        );

        await controller.init();
        await tester.pump(const Duration(milliseconds: 1));

        expect(controller.isEdit, isTrue);
        expect(controller.pet, same(fallbackPet));
        expect(controller.fetchState, FetchState.none);
        expect(controller.name.text, 'Fido');
        expect(controller.category.text, 'Mammal');
        expect(controller.tags.text, 'cute,smart');
        expect(controller.photos, 'http://img/fido.png');
        expect(controller.photoCtrl.text, 'http://img/fido.png');
        verify(mockGetDetail('101')).called(1);
      },
    );

    test('fillTextController copies pet data to text controllers', () {
      final p = MockPets();
      final c = MockCategory();
      final tg = MockTags();

      when(p.name).thenReturn('Zara');
      when(c.name).thenReturn('Cats');
      when(p.category).thenReturn(c);
      when(tg.name).thenReturn('playful');
      when(p.tags).thenReturn([tg]);
      when(p.photos).thenReturn(['http://img/zara.png']);

      controller
        ..pet = p
        ..photos = ''
        ..name.text = ''
        ..category.text = ''
        ..tags.text = ''
        ..photoCtrl.text = '';

      controller.fillTextController();

      expect(controller.name.text, 'Zara');
      expect(controller.category.text, 'Cats');
      expect(controller.tags.text, 'playful');
      expect(controller.photos, 'http://img/zara.png');
      expect(controller.photoCtrl.text, 'http://img/zara.png');
    });
  });
}
