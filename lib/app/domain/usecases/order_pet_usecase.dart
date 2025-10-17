import 'package:pawnco/app/domain/entities/order.dart';
import 'package:pawnco/app/domain/repositories/pets_repository.dart';

class OrderPetUseCase {
  final PetRepository repo;

  OrderPetUseCase(this.repo);

  Future<Order> call(Map<String, dynamic> json) => repo.postPetOrder(json);
}
