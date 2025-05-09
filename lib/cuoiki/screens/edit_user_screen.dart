import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user.dart';
import '../screens/login_screen.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  EditUserScreen({required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email;
    _passwordController.text = widget.user.password;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final dbHelper = DatabaseHelper();
      try {
        final updatedUser = User(
          id: widget.user.id,
          username: _usernameController.text,
          password: _passwordController.text,
          email: _emailController.text,
          avatar: widget.user.avatar,
          createdAt: widget.user.createdAt,
          lastActive: DateTime.now(),
          isAdmin: widget.user.isAdmin,
        );
        await dbHelper.updateUser(updatedUser);
        Navigator.pop(context, updatedUser); // Trả về user đã cập nhật
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật thông tin: $e')),
        );
      }
    }
  }

  void _switchUser() {
    // Đăng xuất và chuyển về màn hình đăng nhập
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa thông tin người dùng')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Tên đăng nhập'),
                validator: (value) => value!.isEmpty ? 'Tên đăng nhập là bắt buộc' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value!.isEmpty || !value.contains('@') ? 'Email không hợp lệ' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Mật khẩu là bắt buộc' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Cập nhật'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _switchUser,
                child: Text('Đổi sang tài khoản người dùng'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Màu xám để phân biệt với nút Cập nhật
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}