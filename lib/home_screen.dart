import 'package:flutter/material.dart';
import 'screens/map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required String userName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Image.asset(
                  'assets/logo_eventfind.png',
                   scale: 3.5,
                ),
              ),
            ),
            const Expanded(
              child: MapScreeen(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildBottomNavigationBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (int index) {
        // Aquí es donde puedes agregar la funcionalidad onPress para cada botón.
      },
      unselectedItemColor: Colors.grey, // Establece el color de los íconos no seleccionados
      selectedItemColor: Colors.blue, // Establece el color de los íconos seleccionados
    );
  }
}