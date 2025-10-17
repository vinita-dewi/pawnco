import 'package:pawnco/app/domain/repositories/pets_repository.dart';

import '../entities/pets.dart';

class GetPetByTagUseCase {
  final PetRepository repo;

  GetPetByTagUseCase(this.repo);

  Future<List<Pets>> call(List<String> tags) => repo.getPetsByTag(tags);
}
