import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/auth.dart'; // Importar el archivo de autenticación

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  // Crear una función asíncrona para manejar el inicio de sesión con Facebook
   // Marcar esta función como 'async'
  Future<void> _handleLoginButton() async {
    Map<String, dynamic> userData = await signInWithFacebook();
    String userName = userData['name'];
    String profilePictureUrl = userData['profilePictureUrl'];

    if (userName.isNotEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userName: userName,
            profilePictureUrl: profilePictureUrl,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              Image.asset(
                'assets/logo_eventfind.png',
                width: 250, // Ajusta el ancho según tus necesidades
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: _handleLoginButton, // Llamar a la función _handleLoginButton
                icon: const Icon(Icons.facebook, color: Colors.white),
                label: const Text('Iniciar sesión con Facebook'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2), // Color del botón de Facebook
                  textStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
