import 'package:dio/dio.dart';
import 'package:pawnco/app/core/constants/api_path.dart';
import 'package:pawnco/app/core/network/dio_client.dart';
import 'package:pawnco/app/data/models/pet_model.dart';

class PetsRemoteSource {
  final DioClient client;
  PetsRemoteSource(this.client);
  Future<List<PetModel>> fetchPets() async {
    var query = {'status': 'available'};
    final res = await client.get(ApiPath.petByStatus, query: query);
    final List data = res.data as List;
    return data.map((e) => PetModel.fromJson(e)).toList();
  }

  Future<PetModel> fetchPetDetail(String id) async {
    final res = await client.get(
      ApiPath.petDetail.replaceAll('{id}', id.toString()),
    );
    return PetModel.fromJson(res.data);
  }

  Future<PetModel> postPet(Map<String, dynamic> json) async {
    final res = await client.post(ApiPath.pet, data: json);

    return PetModel.fromJson(res.data);
  }

  Future<PetModel> putPet(Map<String, dynamic> json, int id) async {
    final res = await client.put(
      ApiPath.petDetail.replaceAll('{id}', id.toString()),
      data: json,
    );

    return PetModel.fromJson(res.data);
  }

  Future<void> deletePet(String id) async {
    await client.delete(
      ApiPath.petDetail.replaceAll('{id}', id.toString()),
      options: Options(
        responseType: ResponseType.plain, // <- don't JSON-decode
        headers: {'Accept': 'text/plain, */*'},
      ),
    );
  }
}
