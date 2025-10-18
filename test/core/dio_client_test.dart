import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pawnco/app/core/network/dio_client.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
import 'dio_client_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late DioClient client;

  setUp(() {
    mockDio = MockDio();
    client = DioClient.from(mockDio);
  });

  Response<T> resp<T>(T data, String path) => Response<T>(
    data: data,
    statusCode: 200,
    requestOptions: RequestOptions(path: path),
  );

  group('DioClient delegates correctly', () {
    test('get passes path, query, options', () async {
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => resp(<String, dynamic>{'ok': true}, '/pets'));

      final options = Options(headers: {'X': '1'});
      final result = await client.get(
        '/pets',
        query: {'status': 'available'},
        options: options,
      );

      expect(result.statusCode, 200);
      verify(
        mockDio.get(
          '/pets',
          queryParameters: {'status': 'available'},
          options: options,
        ),
      ).called(1);
    });

    test('post passes path, data, query, options', () async {
      when(
        mockDio.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => resp({'id': 1}, '/pet'));

      final options = Options(headers: {'A': 'B'});
      final result = await client.post(
        '/pet',
        data: {'name': 'Buddy'},
        query: {'dryRun': true},
        options: options,
      );

      expect(result.data, {'id': 1});
      verify(
        mockDio.post(
          '/pet',
          data: {'name': 'Buddy'},
          queryParameters: {'dryRun': true},
          options: options,
        ),
      ).called(1);
    });

    test('put passes path, data, query, options', () async {
      when(
        mockDio.put(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => resp({'updated': true}, '/pet'));

      final o = Options(extra: {'k': 'v'});
      final result = await client.put(
        '/pet',
        data: {'id': 1, 'name': 'New'},
        query: {'force': 1},
        options: o,
      );

      expect(result.data, {'updated': true});
      verify(
        mockDio.put(
          '/pet',
          data: {'id': 1, 'name': 'New'},
          queryParameters: {'force': 1},
          options: o,
        ),
      ).called(1);
    });

    test('delete passes path, data, query, options', () async {
      when(
        mockDio.delete(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => resp(null, '/pet/1'));

      final o = Options(responseType: ResponseType.plain);
      final result = await client.delete(
        '/pet/1',
        data: {'soft': true},
        query: {'audit': 'y'},
        options: o,
      );

      expect(result.statusCode, 200);
      verify(
        mockDio.delete(
          '/pet/1',
          data: {'soft': true},
          queryParameters: {'audit': 'y'},
          options: o,
        ),
      ).called(1);
    });
  });
}
