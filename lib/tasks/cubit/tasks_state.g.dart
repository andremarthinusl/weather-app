// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TasksState _$TasksStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TasksState', json, ($checkedConvert) {
      final val = TasksState(
        tasks: $checkedConvert(
          'tasks',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
        ),
      );
      return val;
    });

Map<String, dynamic> _$TasksStateToJson(TasksState instance) =>
    <String, dynamic>{'tasks': instance.tasks.map((e) => e.toJson()).toList()};
