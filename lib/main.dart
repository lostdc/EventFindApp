import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/firebase_options.dart';
import 'screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_find/bloc/home_bloc.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Inicializa Firebase y devuelve una instancia de Future<FirebaseApp>
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Event Find',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const LoginScreen(),
          );
        }

        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
  
}
