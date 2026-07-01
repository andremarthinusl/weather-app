// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => $checkedCreate(
  'TaskItem',
  json,
  ($checkedConvert) {
    final val = TaskItem(
      id: $checkedConvert('id', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String),
      scheduledDate: $checkedConvert(
        'scheduled_date',
        (v) => DateTime.parse(v as String),
      ),
      isCompleted: $checkedConvert('is_completed', (v) => v as bool? ?? false),
    );
    return val;
  },
  fieldKeyMap: const {
    'scheduledDate': 'scheduled_date',
    'isCompleted': 'is_completed',
  },
);

Map<String, dynamic> _$TaskItemToJson(TaskItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'scheduled_date': instance.scheduledDate.toIso8601String(),
  'is_completed': instance.isCompleted,
};
