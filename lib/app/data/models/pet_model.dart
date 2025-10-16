import 'package:pawnco/app/data/models/category_model.dart';
import 'package:pawnco/app/data/models/tag_model.dart';
import 'package:pawnco/app/domain/entities/pets.dart';

class PetModel {
  final String? id;
  final String? name;
  final CategoryModel? category;
  final List<TagsModel>? tags;
  final String? status;

  final List<String>? photos;

  const PetModel({
    this.id,
    this.name,
    this.category,
    this.tags,
    this.status,
    this.photos,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    final raw = json['tags'];
    final raw2 = json['photoUrls'];
    return PetModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      category:
          json['category'] == null
              ? null
              : CategoryModel.fromJson(json['category']),
      tags:
          (raw is List)
              ? raw
                  .whereType<Map<String, dynamic>>()
                  .map(TagsModel.fromJson)
                  .toList()
              : <TagsModel>[],
      status: json['status'],
      photos:
          (raw2 is List)
              ? raw2.whereType<String>().map(((e) => e)).toList()
              : <String>[],
    );
  }

  Pets toEntity() => Pets(
    id: id,
    name: name,
    category: category?.toEntity(),
    tags: tags?.map((e) => e.toEntity()).toList(),
    status: status,
    photos: photos,
  );
}
