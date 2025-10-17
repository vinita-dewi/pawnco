import 'package:pawnco/app/domain/entities/order.dart';

class OrderModel {
  final String? id;
  final String? petId;
  final String? shipDate;
  final String? status;
  final bool? isComplete;

  const OrderModel({
    this.id,
    this.petId,
    this.shipDate,
    this.status,
    this.isComplete,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString(),
      petId: json['petId'].toString(),
      shipDate: json['shipDate'],
      status: json['status'],
      isComplete: json['complete'],
    );
  }

  Order toEntity() => Order(
    id: id,
    petId: petId,
    shipDate: shipDate,
    status: status,
    isComplete: isComplete,
  );
}
