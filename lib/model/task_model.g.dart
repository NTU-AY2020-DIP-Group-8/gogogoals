// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(json['name'],
      parent: json['parent'],
      color: json['color'] as int,
      status: json['status'] as int,
      codePoint: json['code_point'] as int,
      id: json['id']);
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'name': instance.name,
      'color': instance.color,
      'status': instance.status,
      'code_point': instance.codePoint
    };
