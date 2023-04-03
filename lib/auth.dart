// auth.dart

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<String> signInWithFacebook() async {
  try {
    // Solicitar inicio de sesión con los permisos básicos (email y public_profile)
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      // El inicio de sesión fue exitoso
      //final AccessToken accessToken = result.accessToken!;
      //print('Access Token: ${accessToken.token}');

      // Obtener datos adicionales del usuario, si es necesario
      final userData = await FacebookAuth.instance.getUserData();
      //print('User Data: $userData');

      // Devolver true ya que el inicio de sesión fue exitoso
      //return true;

      final String? userName = userData['name'];
      return userName ?? ''; // Devuelve el nombre del usuario si está disponible, de lo contrario, devuelve una cadena vacía

    } else {
      //print('Inicio de sesión cancelado por el usuario');
    }
  } on Exception catch (e) {
    // Manejar excepciones
    //print('Error al iniciar sesión con Facebook: $e');
  }

  // Devolver false si el inicio de sesión no fue exitoso o si hubo un error
  //return false;
  return '';
}
