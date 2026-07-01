import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/task_item.dart';
import 'tasks_state.dart';

class TasksCubit extends HydratedCubit<TasksState> {
  TasksCubit() : super(const TasksState());

  void addTask({required String title, required DateTime scheduledDate}) {
    final newTask = TaskItem(
      id: const Uuid().v4(),
      title: title,
      scheduledDate: scheduledDate,
    );
    final updatedTasks = List<TaskItem>.from(state.tasks)..insert(0, newTask);
    
    // Sort tasks by date
    updatedTasks.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
    
    emit(state.copyWith(tasks: updatedTasks));
  }

  void toggleTaskCompletion(String id) {
    final updatedTasks = state.tasks.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  void deleteTask(String id) {
    final updatedTasks = state.tasks.where((task) => task.id != id).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) => TasksState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(TasksState state) => state.toJson();
}
