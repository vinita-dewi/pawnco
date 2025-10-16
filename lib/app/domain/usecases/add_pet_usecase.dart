import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';

class AddPetUsecase {
  final PetRepository repo;

  AddPetUsecase(this.repo);

  Future<Pets> call(Map<String, dynamic> json) => repo.addPet(json);
}
