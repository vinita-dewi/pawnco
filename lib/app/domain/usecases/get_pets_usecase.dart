import 'package:pawnco/app/domain/repositories/pets_repository.dart';

import '../entities/pets.dart';

class GetPetsUseCase {
  final PetRepository repo;

  GetPetsUseCase(this.repo);

  Future<List<Pets>> call() => repo.getPets();
}
