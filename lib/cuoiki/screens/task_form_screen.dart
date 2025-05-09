import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import '../models/user.dart';

class TaskFormScreen extends StatefulWidget {
  final User user;
  final Task? task;

  TaskFormScreen({required this.user, this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = 'To do';
  int _priority = 1;
  DateTime? _dueDate;
  String? _category;
  bool _completed = false;
  String? _assignedTo;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    // Điền sẵn thông tin nếu chỉnh sửa
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _status = widget.task!.status;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
      _category = widget.task!.category;
      _completed = widget.task!.completed;
      _assignedTo = widget.task!.assignedTo;
    } else {
      // Nếu thêm mới, đặt assignedTo mặc định cho người dùng thường
      if (!widget.user.isAdmin) {
        _assignedTo = widget.user.id;
      }
    }
    // Tải danh sách người dùng nếu là Admin
    if (widget.user.isAdmin) {
      _loadUsers();
    }
  }

  void _loadUsers() async {
    final dbHelper = DatabaseHelper();
    try {
      final users = await dbHelper.getAllUsers();
      setState(() => _users = users);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải danh sách người dùng: $e')),
      );
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final dbHelper = DatabaseHelper();
      try {
        final task = Task(
          id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          description: _descriptionController.text,
          status: _status,
          priority: _priority,
          dueDate: _dueDate,
          createdAt: widget.task?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
          assignedTo: _assignedTo,
          createdBy: widget.user.id,
          category: _category,
          attachments: widget.task?.attachments,
          completed: _completed,
        );

        if (widget.task == null) {
          await dbHelper.insertTask(task);
        } else {
          await dbHelper.updateTask(task);
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu công việc: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Thêm công việc' : 'Sửa công việc')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
                validator: (value) => value!.isEmpty ? 'Tiêu đề là bắt buộc' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Mô tả là bắt buộc' : null,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(labelText: 'Trạng thái'),
                items: ['To do', 'In progress', 'Done', 'Cancelled']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Độ ưu tiên'),
                items: [1, 2, 3]
                    .map((priority) => DropdownMenuItem(value: priority, child: Text('$priority')))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
              ),
              if (widget.user.isAdmin) // Chỉ hiển thị cho Admin
                DropdownButtonFormField<String>(
                  value: _assignedTo,
                  decoration: InputDecoration(labelText: 'Gán cho'),
                  items: _users
                      .map((user) => DropdownMenuItem(
                    value: user.id,
                    child: Text(user.username),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _assignedTo = value),
                  validator: (value) => value == null ? 'Vui lòng chọn người được gán' : null,
                ),
              if (!widget.user.isAdmin) // Hiển thị thông tin cho người dùng thường
                TextFormField(
                  initialValue: widget.user.username,
                  decoration: InputDecoration(labelText: 'Gán cho'),
                  readOnly: true,
                ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ngày đến hạn'),
                readOnly: true,
                controller: TextEditingController(
                  text: _dueDate != null ? DateFormat('dd/MM/yyyy').format(_dueDate!) : '',
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) setState(() => _dueDate = pickedDate);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Danh mục'),
                initialValue: _category,
                onChanged: (value) => _category = value.isEmpty ? null : value,
              ),
              CheckboxListTile(
                title: Text('Hoàn thành'),
                value: _completed,
                onChanged: (value) => setState(() => _completed = value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.task == null ? 'Thêm' : 'Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}