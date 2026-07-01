import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

  void _addToCalendar(TaskItem task, BuildContext context) {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add to Calendar is only supported on Android/iOS natively.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Activity Planner', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C3E50), Color(0xFF3498DB)],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              if (state.tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.directions_run_rounded, size: 80, color: Colors.white70),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'No activities planned!',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Plan an outdoor activity\nand we\'ll check the weather for you.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TaskListTile(
                    task: task,
                    weatherWarningBadge: _getWeatherBadge(task, context),
                    onToggle: () => context.read<TasksCubit>().toggleTaskCompletion(task.id),
                    onDelete: () => context.read<TasksCubit>().deleteTask(task.id),
                    onAddToCalendar: () => _addToCalendar(task, context),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(AddTaskPage.route()),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2C3E50),
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Plan Activity', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
