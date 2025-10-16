import 'package:pawnco/app/domain/entities/pets.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';

class EditPetUsecase {
  final PetRepository repo;

  EditPetUsecase(this.repo);

  Future<Pets> call(Map<String, dynamic> json, int id) =>
      repo.editPet(json, id);
}
