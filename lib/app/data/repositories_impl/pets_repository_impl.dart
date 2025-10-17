import 'package:pawnco/app/data/sources/pets_remote_source.dart';
import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';

class PetsRepositoryImpl extends PetRepository {
  final PetsRemoteSource remoteSource;

  PetsRepositoryImpl(this.remoteSource);

  @override
  Future<List<Pets>> getPets() async {
    final model = await remoteSource.fetchPets();
    return model.map((m) => m.toEntity()).toList();
  }

  Future<List<Pets>> getPetsByTag(List<String> tags) async {
    final model = await remoteSource.fetchPetsByTag(tags);
    return model.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Pets> getPetDetail(String id) async {
    final model = await remoteSource.fetchPetDetail(id);
    return model.toEntity();
  }

  @override
  Future<Pets> addPet(Map<String, dynamic> json) async {
    final model = await remoteSource.postPet(json);
    return model.toEntity();
  }

  @override
  Future<Pets> editPet(Map<String, dynamic> json) async {
    final model = await remoteSource.putPet(json);
    return model.toEntity();
  }

  @override
  Future<void> deletePet(String id) async {
    await remoteSource.deletePet(id);
  }
}
