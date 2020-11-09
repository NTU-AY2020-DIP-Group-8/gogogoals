// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(json['name'] as String,
      parent: json['parent'] as String,
      isCompleted: json['completed'] as int,
      deadline: json['deadline'] == null
          ? null
          : json['deadline'].toDate(),
      id: json['id'] as String,
      url: json['url'] as String);
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'name': instance.name,
      'url': instance.url,
      'completed': instance.isCompleted,
      'deadline': instance.deadline?.toIso8601String()
    };
