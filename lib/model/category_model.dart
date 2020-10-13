import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/uuid.dart';

part 'category_model.g.dart';

@JsonSerializable()
class Category {
  String id;
  String name;
  // int status;
  Category(
    this.name, {
    // @required this.status,
    String id,
  }) : this.id = id ?? Uuid().generateV4();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$TaskFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TaskFromJson`.
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
