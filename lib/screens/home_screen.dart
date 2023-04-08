import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_find/bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {

  final String userName;
  final String profilePictureUrl;
  

  const HomeScreen({
    Key? key,
    required this.userName,
    required this.profilePictureUrl,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  //aqui cuando presionan algun boton del menu inferior home cambia el valor del indice
  void _onItemTapped(int index) {
    BlocProvider.of<HomeBloc>(context).add(ChangeSelectedIndex(index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text((state.selectedIndex).toString()),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //MapScreeen(profilePictureUrl: widget.profilePictureUrl),
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
                Expanded(
                  child: MapScreeen(profilePictureUrl: widget.profilePictureUrl),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomNavigationBar(state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(HomeState state) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Color.fromARGB(255, 70, 43, 226),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
          backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
          backgroundColor: Colors.yellow,
        ),
      ],
      currentIndex: state.selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
