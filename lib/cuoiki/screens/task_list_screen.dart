import 'package:app_03/cuoiki/screens/task_item.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import '../models/user.dart';
import 'task_form_screen.dart';
import 'task_detail_screen.dart';
import 'edit_user_screen.dart';

class TaskListScreen extends StatefulWidget {
  final User user;
  TaskListScreen({required this.user});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final dbHelper = DatabaseHelper();
  List<Task> tasks = [];
  String? filterStatus;
  String? filterCategory;
  String searchQuery = '';
  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    print('User: ${currentUser.username}, isAdmin: ${currentUser.isAdmin}'); // Debug
    _loadTasks();
  }

  void _loadTasks() async {
    try {
      final loadedTasks = await dbHelper.getTasks(
        userId: currentUser.isAdmin ? null : currentUser.id,
        isAdmin: currentUser.isAdmin,
        status: filterStatus,
        category: filterCategory,
      );
      print('Loaded tasks count: ${loadedTasks.length}'); // Debug
      setState(() => tasks = loadedTasks);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải công việc: $e')),
      );
    }
  }

  void _searchTasks(String query) async {
    setState(() => searchQuery = query);
    try {
      final loadedTasks = await dbHelper.searchTasks(
        query,
        userId: currentUser.isAdmin ? null : currentUser.id,
        isAdmin: currentUser.isAdmin,
      );
      print('Searched tasks count: ${loadedTasks.length}'); // Debug
      setState(() => tasks = loadedTasks);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tìm kiếm: $e')),
      );
    }
  }

  void _editUserProfile() async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(user: currentUser),
      ),
    );
    if (updatedUser != null) {
      setState(() {
        currentUser = updatedUser;
      });
      _loadTasks(); // Tải lại danh sách sau khi cập nhật user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách công việc'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: _editUserProfile,
            tooltip: 'Chỉnh sửa thông tin cá nhân',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                filterStatus = value == 'Tất cả' ? null : value;
                _loadTasks();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Tất cả', child: Text('Tất cả')),
              PopupMenuItem(value: 'To do', child: Text('Cần làm')),
              PopupMenuItem(value: 'In progress', child: Text('Đang thực hiện')),
              PopupMenuItem(value: 'Done', child: Text('Hoàn thành')),
              PopupMenuItem(value: 'Cancelled', child: Text('Đã hủy')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchTasks,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm công việc',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskItem(
                  task: task,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailScreen(task: task, user: currentUser),
                    ),
                  ),
                  onComplete: () async {
                    try {
                      final updatedTask = Task(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        status: task.status,
                        priority: task.priority,
                        dueDate: task.dueDate,
                        createdAt: task.createdAt,
                        updatedAt: DateTime.now(),
                        assignedTo: task.assignedTo,
                        createdBy: task.createdBy,
                        category: task.category,
                        attachments: task.attachments,
                        completed: !task.completed,
                      );
                      await dbHelper.updateTask(updatedTask);
                      _loadTasks();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi khi cập nhật: $e')),
                      );
                    }
                  },
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskFormScreen(user: currentUser, task: task),
                    ),
                  ).then((_) => _loadTasks()),
                  onDelete: () async {
                    try {
                      await dbHelper.deleteTask(task.id);
                      _loadTasks();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi khi xóa: $e')),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskFormScreen(user: currentUser),
          ),
        ).then((_) => _loadTasks()),
        child: Icon(Icons.add),
      ),
    );
  }
}