import 'package:pawnco/app/domain/entities/tags.dart';

import 'category.dart';

class Pets {
  final String? id;
  final String? name;
  final Category? category;
  final List<Tags>? tags;
  final String? status;

  final List<String>? photos;

  const Pets({
    this.id,
    this.name,
    this.category,
    this.tags,
    this.status,
    this.photos,
  });
}
