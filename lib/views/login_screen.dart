import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLogin = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = _isLogin
            ? await _authController.login(_emailController.text, _passwordController.text)
            : await _authController.register(_nameController.text, _emailController.text, _passwordController.text);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen(user: user)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Iniciar Sesión' : 'Registrarse'),
        backgroundColor: Colors.teal[700],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isLogin)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            icon: Icon(Icons.person, color: Colors.teal),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                          ),
                          validator: (value) => value!.isEmpty ? 'Ingresa tu nombre' : null,
                        ),
                      ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        icon: Icon(Icons.email, color: Colors.teal),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                      ),
                      validator: (value) => value!.isEmpty ? 'Ingresa tu correo' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        icon: Icon(Icons.lock, color: Colors.teal),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                      ),
                      obscureText: true,
                      validator: (value) => value!.isEmpty ? 'Ingresa tu contraseña' : null,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: Icon(_isLogin ? Icons.login : Icons.person_add),
                      label: Text(_isLogin ? 'Iniciar Sesión' : 'Registrarse'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(double.infinity, 50), // Botón ancho completo
                      ),
                      onPressed: _submit,
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => setState(() => _isLogin = !_isLogin),
                        child: Text(
                          _isLogin ? '¿No tienes cuenta? Regístrate' : '¿Ya tienes cuenta? Inicia sesión',
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
