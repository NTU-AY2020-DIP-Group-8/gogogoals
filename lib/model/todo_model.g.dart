// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  if (json['deadline'] == null) {
    return Todo(json['name'] as String,
        parent: json['parent'] as String,
        isCompleted: json['completed'] as int,
        id: json['id'] as String,
        deadline: null);
  }
  return Todo(json['name'] as String,
      parent: json['parent'] as String,
      isCompleted: json['completed'] as int,
      id: json['id'] as String,
      deadline: json['deadline'].toDate() as DateTime);
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'name': instance.name,
      'completed': instance.isCompleted,
      'deadline': instance.deadline
    };
