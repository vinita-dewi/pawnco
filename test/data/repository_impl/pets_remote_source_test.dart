import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/core/constants/api_path.dart';
import 'package:pawnco/app/core/network/dio_client.dart';
import 'package:pawnco/app/data/models/order_model.dart';
import 'package:pawnco/app/data/models/pet_model.dart';
import 'package:pawnco/app/data/sources/pets_remote_source.dart';

import 'pets_remote_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DioClient>()])
void main() {
  late PetsRemoteSource source;
  late MockDioClient mockClient;

  setUp(() {
    mockClient = MockDioClient();
    source = PetsRemoteSource(mockClient);
  });

  group('PetsRemoteSource', () {
    test('fetchPets should return list of PetModel', () async {
      // Arrange
      final mockData = [
        {'id': 1, 'name': 'Dog'},
        {'id': 2, 'name': 'Cat'},
      ];
      when(
        mockClient.get(ApiPath.petByStatus, query: anyNamed('query')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiPath.petByStatus),
          data: mockData,
        ),
      );

      // Act
      final result = await source.fetchPets();

      // Assert
      expect(result, isA<List<PetModel>>());
      expect(result.length, 2);
      expect(result.first.name, 'Dog');
      verify(
        mockClient.get(ApiPath.petByStatus, query: {'status': 'available'}),
      ).called(1);
    });

    test(
      'fetchPetsByTag should return list of PetModel filtered by Tag',
      () async {
        final mockData = [
          {'id': 3, 'name': 'Bird'},
        ];

        when(
          mockClient.get(
            any,
            query: anyNamed('query'),
            options: anyNamed('options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/pet/findByTags'),
            data: mockData,
            statusCode: 200,
          ),
        );

        final result = await source.fetchPetsByTag(['cute']);

        expect(result, isA<List<PetModel>>());
        expect(result.first.name, 'Bird');
        verify(
          mockClient.get(
            ApiPath.petByTags,
            query: {
              'tags': ['cute'],
            },
          ),
        ).called(1);
      },
    );

    test(
      'fetchPetDetail should return a PetModel with the correct id',
      () async {
        final mockData = {'id': 10, 'name': 'Hamster'};

        when(
          mockClient.get('${ApiPath.petDetail.replaceAll('{id}', '10')}'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: ApiPath.petDetail.replaceAll('{id}', '10'),
            ),
            data: mockData,
          ),
        );

        final result = await source.fetchPetDetail('10');

        expect(result, isA<PetModel>());
        expect(result.id, '10');
        expect(result.name, 'Hamster');
        verify(
          mockClient.get(ApiPath.petDetail.replaceAll('{id}', '10')),
        ).called(1);
      },
    );

    test('postPet should call POST and return PetModel', () async {
      final json = {'id': 5, 'name': 'Turtle'};
      when(mockClient.post(ApiPath.pet, data: json)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiPath.pet),
          data: json,
        ),
      );

      final result = await source.postPet(json);

      expect(result, isA<PetModel>());
      expect(result.id, '5');
      verify(mockClient.post(ApiPath.pet, data: json)).called(1);
    });

    test('putPet should call PUT and return PetModel', () async {
      final json = {'id': 7, 'name': 'Rabbit'};
      when(mockClient.put(ApiPath.pet, data: json)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiPath.pet),
          data: json,
        ),
      );

      final result = await source.putPet(json);

      expect(result, isA<PetModel>());
      expect(result.name, 'Rabbit');
      verify(mockClient.put(ApiPath.pet, data: json)).called(1);
    });

    test(
      'deletePet should call DELETE with correct path and options',
      () async {
        when(
          mockClient.delete(ApiPath.pet, options: anyNamed('options')),
        ).thenAnswer(
          (_) async =>
              Response(requestOptions: RequestOptions(path: '/'), data: null),
        );

        await source.deletePet('12');

        verify(
          mockClient.delete(
            ApiPath.petDetail.replaceAll('{id}', '12'),
            options: anyNamed('options'),
          ),
        ).called(1);
      },
    );

    test('postPetOrder should call POST and return OrderModel', () async {
      final json = {'id': 1, 'petId': 2};
      when(mockClient.post(ApiPath.orderPet, data: json)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiPath.orderPet),
          data: json,
        ),
      );

      final result = await source.postPetOrder(json);

      expect(result, isA<OrderModel>());
      expect(result.id, '1');
      verify(mockClient.post(ApiPath.orderPet, data: json)).called(1);
    });
  });
}
