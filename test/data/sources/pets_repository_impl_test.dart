import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/core/constants/api_path.dart';
import 'package:pawnco/app/core/network/dio_client.dart';
import 'package:pawnco/app/data/models/order_model.dart';
import 'package:pawnco/app/data/models/pet_model.dart';
import 'package:pawnco/app/data/sources/pets_remote_source.dart';

@GenerateNiceMocks([MockSpec<DioClient>()])
import 'pets_repository_impl_test.mocks.dart';

void main() {
  late PetsRemoteSource source;
  late MockDioClient mockClient;

  // Small helper to build Response objects
  Response<T> makeResponse<T>(T data, {String path = '/'}) {
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: data,
      statusCode: 200,
    );
  }

  setUp(() {
    mockClient = MockDioClient();
    source = PetsRemoteSource(mockClient);
  });

  group('PetsRemoteSource', () {
    test(
      'fetchPets returns list of PetModel and calls correct endpoint with query',
      () async {
        // Arrange
        final mockData = [
          {'id': 1, 'name': 'Dog'},
          {'id': 2, 'name': 'Cat'},
        ];
        when(
          mockClient.get(
            any,
            query: anyNamed('query'),
            options: anyNamed('options'),
          ),
        ).thenAnswer(
          (_) async =>
              makeResponse<List<dynamic>>(mockData, path: ApiPath.petByStatus),
        );

        // Act
        final result = await source.fetchPets();

        // Assert
        expect(result, isA<List<PetModel>>());
        expect(result.length, 2);
        expect(result.first.name, 'Dog');

        // Verify path + capture and assert query contents
        final captured =
            verify(
              mockClient.get(
                ApiPath.petByStatus,
                query: captureAnyNamed('query'),
                options: anyNamed('options'),
              ),
            ).captured;
        final query = captured.single as Map<String, dynamic>;
        expect(query['status'], 'available');
      },
    );

    test(
      'fetchPetsByTag returns list of PetModel and sends tags as query',
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
          (_) async =>
              makeResponse<List<dynamic>>(mockData, path: ApiPath.petByTags),
        );

        final result = await source.fetchPetsByTag(['cute']);

        expect(result, isA<List<PetModel>>());
        expect(result.first.name, 'Bird');

        final captured =
            verify(
              mockClient.get(
                ApiPath.petByTags,
                query: captureAnyNamed('query'),
                options: anyNamed('options'),
              ),
            ).captured;
        final query = captured.single as Map<String, dynamic>;
        expect(query['tags'], ['cute']);
      },
    );

    test('fetchPetDetail returns a PetModel and hits /pet/{id}', () async {
      const id = '10';
      final mockData = {'id': id, 'name': 'Hamster'};

      when(
        mockClient.get(
          any,
          query: anyNamed('query'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => makeResponse<Map<String, dynamic>>(
          mockData,
          path: ApiPath.petDetail.replaceAll('{id}', id),
        ),
      );

      final result = await source.fetchPetDetail(id);

      expect(result, isA<PetModel>());
      // To avoid int/string mismatch in different model implementations, compare via toString
      expect(result.id.toString(), id);
      expect(result.name, 'Hamster');

      verify(
        mockClient.get(
          ApiPath.petDetail.replaceAll('{id}', id),
          query: anyNamed('query'),
          options: anyNamed('options'),
        ),
      ).called(1);
    });

    test('postPet returns PetModel and calls POST /pet', () async {
      final body = {'id': 5, 'name': 'Turtle'};
      when(
        mockClient.post(
          any,
          data: anyNamed('data'),
          query: anyNamed('query'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async =>
            makeResponse<Map<String, dynamic>>(body, path: ApiPath.pet),
      );

      final result = await source.postPet(body);

      expect(result, isA<PetModel>());
      expect(result.id.toString(), '5');
      expect(result.name, 'Turtle');

      final captured =
          verify(
            mockClient.post(
              ApiPath.pet,
              data: captureAnyNamed('data'),
              query: anyNamed('query'),
              options: anyNamed('options'),
            ),
          ).captured;
      final sent = captured.single as Map<String, dynamic>;
      expect(sent['name'], 'Turtle');
    });

    test('putPet returns PetModel and calls PUT /pet', () async {
      final body = {'id': 7, 'name': 'Rabbit'};
      when(
        mockClient.put(
          any,
          data: anyNamed('data'),
          query: anyNamed('query'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async =>
            makeResponse<Map<String, dynamic>>(body, path: ApiPath.pet),
      );

      final result = await source.putPet(body);

      expect(result, isA<PetModel>());
      expect(result.id.toString(), '7');
      expect(result.name, 'Rabbit');

      final captured =
          verify(
            mockClient.put(
              ApiPath.pet,
              data: captureAnyNamed('data'),
              query: anyNamed('query'),
              options: anyNamed('options'),
            ),
          ).captured;
      final sent = captured.single as Map<String, dynamic>;
      expect(sent['name'], 'Rabbit');
    });

    test('deletePet calls DELETE /pet/{id} with Options', () async {
      const id = '12';

      when(
        mockClient.delete(
          any,
          data: anyNamed('data'),
          query: anyNamed('query'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => makeResponse<String>(
          '',
          path: ApiPath.petDetail.replaceAll('{id}', id),
        ),
      );

      await source.deletePet(id);

      verify(
        mockClient.delete(
          ApiPath.petDetail.replaceAll('{id}', id),
          data: anyNamed('data'),
          query: anyNamed('query'),
          options: anyNamed('options'),
        ),
      ).called(1);
    });

    test(
      'postPetOrder returns OrderModel and calls POST /store/order',
      () async {
        final body = {'id': 1, 'petId': 2};
        when(
          mockClient.post(
            any,
            data: anyNamed('data'),
            query: anyNamed('query'),
            options: anyNamed('options'),
          ),
        ).thenAnswer(
          (_) async =>
              makeResponse<Map<String, dynamic>>(body, path: ApiPath.orderPet),
        );

        final result = await source.postPetOrder(body);

        expect(result, isA<OrderModel>());
        expect(result.id.toString(), '1');

        final captured =
            verify(
              mockClient.post(
                ApiPath.orderPet,
                data: captureAnyNamed('data'),
                query: anyNamed('query'),
                options: anyNamed('options'),
              ),
            ).captured;
        final sent = captured.single as Map<String, dynamic>;
        expect(sent['petId'].toString(), '2');
      },
    );
  });
}
