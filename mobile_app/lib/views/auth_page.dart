import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseService = FirebaseService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await _firebaseService.signIn(_emailController.text, _passwordController.text);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    try {
      await _firebaseService.register(_emailController.text, _passwordController.text);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng nhập / Đăng ký')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            if (_errorMessage != null) Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Mật khẩu')),
            SizedBox(height: 20),
            _isLoading ? CircularProgressIndicator() : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _signIn, child: Text('Đăng nhập')),
                ElevatedButton(onPressed: _register, child: Text('Đăng ký')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
