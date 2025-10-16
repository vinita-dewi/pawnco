import 'package:pawnco/app/domain/repositories/pets_repository.dart';

import '../entities/pets.dart';

class GetPetDetailUsecase {
  final PetRepository repo;

  GetPetDetailUsecase(this.repo);

  Future<Pets> call(String id) => repo.getPetDetail(id);
}
