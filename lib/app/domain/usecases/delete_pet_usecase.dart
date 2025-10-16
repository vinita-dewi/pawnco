import 'package:pawnco/app/domain/repositories/pets_repository.dart';

class DeletePetUsecase {
  final PetRepository repo;

  DeletePetUsecase(this.repo);

  Future<dynamic> call(String id) => repo.deletePet(id);
}
