import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<Map<String, dynamic>> signInWithFacebook() async {
  Map<String, dynamic> resultData = {'name': '', 'profilePictureUrl': ''};

  try {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData(fields: 'name,email,picture.width(200)');

      final String? userName = userData['name'];
      resultData['name'] = userName ?? '';

      final String? profilePictureUrl = userData['picture']['data']['url'];
      resultData['profilePictureUrl'] = profilePictureUrl ?? '';
    }
  } on Exception catch (e) {
    print('Error al iniciar sesión con Facebook: $e');
  }

  return resultData;
}