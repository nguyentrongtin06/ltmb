import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  TaskItem({
    required this.task,
    required this.onTap,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getPriorityColor() {
    switch (task.priority) {
      case 3:
        return Colors.red;
      case 2:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _getStatusText() {
    switch (task.status) {
      case 'To do':
        return 'Cần làm';
      case 'In progress':
        return 'Đang thực hiện';
      case 'Done':
        return 'Hoàn thành';
      case 'Cancelled':
        return 'Đã hủy';
      default:
        return task.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getPriorityColor(),
          child: Text(task.priority.toString()),
        ),
        title: Text(
          task.title,
          style: TextStyle(decoration: task.completed ? TextDecoration.lineThrough : null),
        ),
        subtitle: Text(_getStatusText()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(task.completed ? Icons.check_circle : Icons.circle_outlined),
              onPressed: onComplete,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}