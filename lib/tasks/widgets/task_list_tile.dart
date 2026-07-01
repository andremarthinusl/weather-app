import 'package:flutter/material.dart';
import 'package:flutter_weather/weather/widgets/glass_card.dart';
import 'package:intl/intl.dart';
import '../models/task_item.dart';
import 'centered_notification.dart';

class TaskListTile extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onAddToCalendar;
  final Widget? weatherWarningBadge;

  const TaskListTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onAddToCalendar,
    this.weatherWarningBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Dismissible(
        key: ValueKey(task.id),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 32),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete_outline, color: Colors.white, size: 32),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            onToggle();
            showCenteredNotification(
              context,
              '${task.title}\nCompleted!',
              Icons.check_circle_outline,
              Colors.greenAccent,
            );
          } else if (direction == DismissDirection.endToStart) {
            onDelete();
            showCenteredNotification(
              context,
              '${task.title}\nCancelled',
              Icons.delete_outline,
              Colors.redAccent,
            );
          }
        },
        child: GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.directions_run_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            decorationColor: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, size: 14, color: Colors.white70),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('EEEE, MMM d').format(task.scheduledDate),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onSelected: (value) {
                      if (value == 'calendar') {
                        onAddToCalendar();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'calendar',
                        child: Row(
                          children: [
                            Icon(Icons.edit_calendar_rounded, color: Color(0xFF3498DB), size: 20),
                            SizedBox(width: 12),
                            Text('Add to Calendar', style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                            SizedBox(width: 12),
                            Text('Delete Activity', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (weatherWarningBadge != null) ...[
                const SizedBox(height: 16),
                weatherWarningBadge!,
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => onToggle(),
                        activeColor: const Color(0xFF3498DB),
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        side: const BorderSide(color: Colors.white70, width: 2),
                      ),
                      Text(
                        task.isCompleted ? 'Completed' : 'Mark as Done',
                        style: TextStyle(
                          color: task.isCompleted ? Colors.white54 : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: onAddToCalendar,
                    icon: const Icon(Icons.add_to_drive_rounded, color: Colors.white70, size: 18),
                    label: const Text('Export', style: TextStyle(color: Colors.white70)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
