import 'package:flutter/material.dart';
import 'package:lab_11/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:lab_11/pages/home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  void _submit() async {
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    String? error;

    if (_formKey.currentState!.validate()) {
      if (_isLogin) {
        error = await authProvider.loginUser(
          _usernameController.text,
          _passwordController.text,
        );
      } else {
        error = await authProvider.registerUser(
          _usernameController.text,
          _passwordController.text,
        );
      }

      if (!mounted) return;

      if (error == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Please enter username";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Username'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Please enter password";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLogin ? 'Login' : 'Register'),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? "Create an account"
                        : "Already have an account? Login",
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: SvgPicture.asset(
                    'assets/google_icon.svg',
                    height: 24,
                  ),
                  label: Text('Sign in with Google'),
                  onPressed: () async {
                    final error = await Provider.of<MyAuthProvider>(
                      context, 
                      listen: false,
                    ).signInWithGoogle();
                    
                    if (error == null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}