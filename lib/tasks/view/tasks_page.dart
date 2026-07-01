import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:weather_repository/weather_repository.dart' show WeatherCondition;
import '../../weather/cubit/weather_cubit.dart';
import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';
import '../models/task_item.dart';
import '../widgets/task_list_tile.dart';
import 'add_task_page.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const TasksPage(),
    );
  }

  void _addToCalendar(TaskItem task) {
    final Event event = Event(
      title: task.title,
      description: 'Weather-Aware Task',
      location: '',
      startDate: task.scheduledDate,
      endDate: task.scheduledDate.add(const Duration(hours: 1)),
      allDay: true,
    );
    Add2Calendar.addEvent2Cal(event);
  }

  Widget? _getWeatherBadge(TaskItem task, BuildContext context) {
    final weatherState = context.read<WeatherCubit>().state.weather;
    if (weatherState.dailyForecast.isEmpty) return null;

    // Find forecast for the scheduled date
    final taskDate = DateTime(task.scheduledDate.year, task.scheduledDate.month, task.scheduledDate.day);
    
    for (final forecast in weatherState.dailyForecast) {
      final forecastDate = DateTime(forecast.time.year, forecast.time.month, forecast.time.day);
      if (forecastDate.isAtSameMomentAs(taskDate)) {
        if (forecast.condition == WeatherCondition.rainy || forecast.condition == WeatherCondition.snowy) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, size: 14, color: Colors.white),
                SizedBox(width: 4),
                Text('Bad Weather!', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        } else if (forecast.condition == WeatherCondition.clear) {
           return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wb_sunny, size: 14, color: Colors.white),
                SizedBox(width: 4),
                Text('Perfect Weather', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Smart Tasks'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state.tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 80, color: Colors.white54),
                  SizedBox(height: 16),
                  Text(
                    'No tasks yet!',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add a task to see weather insights.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return TaskListTile(
                task: task,
                weatherWarningBadge: _getWeatherBadge(task, context),
                onToggle: () => context.read<TasksCubit>().toggleTaskCompletion(task.id),
                onDelete: () => context.read<TasksCubit>().deleteTask(task.id),
                onAddToCalendar: () => _addToCalendar(task),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(AddTaskPage.route()),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
