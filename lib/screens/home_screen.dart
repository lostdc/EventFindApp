import 'package:flutter/material.dart';
import 'package:event_find/screens/map_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_find/bloc/home_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

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

  //aqui cuando presionan algun boton del menu inferior home cambia el valor del indice
  void _onItemTapped(int index) {
    BlocProvider.of<HomeBloc>(context).add(ChangeSelectedIndex(index));
  }



                

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: WillPopScope(
            onWillPop: () async {
              if (OverlaySupportEntry.of(context) != null) {
                OverlaySupportEntry.of(context)!.dismiss();
                return false;
              }
              return true;
            },
              child: Column(
              children: [
                const Padding(
                      padding: EdgeInsets.only(top: 35)
                ),
                Image.asset(
                  'assets/logo_eventfind.png',
                  scale: 3.5,
                ),
                Expanded(
                  child: InteractiveMapScreen(profilePictureUrl: widget.profilePictureUrl),
                )
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(state),
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
          backgroundColor: Color.fromARGB(255, 0, 60, 255),
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
          backgroundColor: Color.fromARGB(255, 251, 130, 0),
        ),
      ],
      currentIndex: state.selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
