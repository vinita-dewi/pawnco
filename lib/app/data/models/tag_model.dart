import 'package:pawnco/app/domain/entities/tags.dart';

class TagsModel {
  final int? id;
  final String? name;
  const TagsModel({this.id, this.name});

  factory TagsModel.fromJson(Map<String, dynamic> json) =>
      TagsModel(id: json['id'], name: json['name']);

  Tags toEntity() => Tags(id: id, name: name);
}
