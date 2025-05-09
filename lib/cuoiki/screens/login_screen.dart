import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user.dart';
import 'task_list_screen.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLogin = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final dbHelper = DatabaseHelper();
      try {
        if (_isLogin) {
          final user = await dbHelper.getUserByCredentials(
            _usernameController.text,
            _passwordController.text,
          );
          if (user != null) {
            await dbHelper.updateUser(user.copyWith(lastActive: DateTime.now()));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TaskListScreen(user: user)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tên đăng nhập hoặc mật khẩu không đúng')),
            );
          }
        } else {
          const uuid = Uuid();
          final user = User(
            id: uuid.v4(),
            username: _usernameController.text,
            password: _passwordController.text,
            email: _emailController.text,
            createdAt: DateTime.now(),
            lastActive: DateTime.now(),
            isAdmin: _usernameController.text.toLowerCase() == 'admin', // Chỉ admin có username "admin"
          );
          await dbHelper.insertUser(user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TaskListScreen(user: user)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xảy ra lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Đăng nhập' : 'Đăng ký')),
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
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Mật khẩu là bắt buộc' : null,
              ),
              if (!_isLogin)
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                  value!.isEmpty || !value.contains('@') ? 'Email không hợp lệ' : null,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Đăng nhập' : 'Đăng ký'),
              ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'Tạo tài khoản mới' : 'Đã có tài khoản? Đăng nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on User {
  User copyWith({DateTime? lastActive}) {
    return User(
      id: id,
      username: username,
      password: password,
      email: email,
      avatar: avatar,
      createdAt: createdAt,
      lastActive: lastActive ?? this.lastActive,
      isAdmin: isAdmin,
    );
  }
}