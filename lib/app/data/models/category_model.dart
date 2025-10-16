import 'package:pawnco/app/domain/entities/category.dart';

class CategoryModel {
  final int? id;
  final String? name;
  const CategoryModel({this.id, this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(id: json['id'], name: json['name']);

  Category toEntity() => Category(id: id, name: name);
}
