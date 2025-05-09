import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import '../models/user.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final User user;

  TaskDetailScreen({required this.task, required this.user});

  String _getStatusText(String status) {
    switch (status) {
      case 'To do':
        return 'Cần làm';
      case 'In progress':
        return 'Đang thực hiện';
      case 'Done':
        return 'Hoàn thành';
      case 'Cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(user: user, task: task),
                ),
              ).then((_) => Navigator.pop(context));
            },
            tooltip: 'Chỉnh sửa công việc',
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final dbHelper = DatabaseHelper();
              try {
                await dbHelper.deleteTask(task.id);
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi khi xóa công việc: $e')),
                );
              }
            },
            tooltip: 'Xóa công việc',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tiêu đề: ${task.title}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Mô tả: ${task.description}'),
            SizedBox(height: 8),
            Text('Trạng thái: ${_getStatusText(task.status)}'),
            SizedBox(height: 8),
            Text('Độ ưu tiên: ${task.priority}'),
            SizedBox(height: 8),
            Text('Ngày đến hạn: ${task.dueDate != null ? DateFormat('dd/MM/yyyy').format(task.dueDate!) : 'Không có'}'),
            SizedBox(height: 8),
            Text('Danh mục: ${task.category ?? 'Không có'}'),
            SizedBox(height: 8),
            Text('Hoàn thành: ${task.completed ? 'Có' : 'Không'}'),
            SizedBox(height: 8),
            Text('Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(task.createdAt)}'),
            SizedBox(height: 8),
            Text('Ngày cập nhật: ${DateFormat('dd/MM/yyyy HH:mm').format(task.updatedAt)}'),
            SizedBox(height: 8),
            Text('Gán cho: ${task.assignedTo ?? 'Chưa gán'}'),
          ],
        ),
      ),
    );
  }
}