import 'package:pawnco/app/domain/entities/pets.dart';

abstract class PetRepository {
  Future<List<Pets>> getPets();

  Future<Pets> getPetDetail(String id);

  Future<Pets> addPet(Map<String, dynamic> json);

  Future<Pets> editPet(Map<String, dynamic> json, int id);

  Future deletePet(String id);
}
