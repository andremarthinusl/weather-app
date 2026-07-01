import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/task_item.dart';

part 'tasks_state.g.dart';

@JsonSerializable()
class TasksState extends Equatable {
  final List<TaskItem> tasks;

  const TasksState({
    this.tasks = const [],
  });

  TasksState copyWith({
    List<TaskItem>? tasks,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
    );
  }

  factory TasksState.fromJson(Map<String, dynamic> json) => _$TasksStateFromJson(json);
  Map<String, dynamic> toJson() => _$TasksStateToJson(this);

  @override
  List<Object?> get props => [tasks];
}
