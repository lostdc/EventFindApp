import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/firebase_options.dart';
import 'screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_find/bloc/home_bloc.dart';
import 'package:event_find/bloc/map_bloc.dart';
import 'package:event_find/services/firebase_storage_service.dart';
import 'package:event_find/repositories/map_marker_repository.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(
          create: (context) => MapBloc(
            firebaseStorageService: FirebaseStorageService(),
            mapMarkerRepository: MapMarkerRepository(FirebaseStorageService()),
          ),
        ),
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
          return OverlaySupport(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Event Find',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const LoginScreen(),
            )
          );
        }

        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
  
}
