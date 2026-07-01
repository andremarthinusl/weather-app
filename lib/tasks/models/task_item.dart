import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_item.g.dart';

@JsonSerializable()
class TaskItem extends Equatable {
  final String id;
  final String title;
  final DateTime scheduledDate;
  final bool isCompleted;

  const TaskItem({
    required this.id,
    required this.title,
    required this.scheduledDate,
    this.isCompleted = false,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    DateTime? scheduledDate,
    bool? isCompleted,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) => _$TaskItemFromJson(json);
  Map<String, dynamic> toJson() => _$TaskItemToJson(this);

  @override
  List<Object?> get props => [id, title, scheduledDate, isCompleted];
}
