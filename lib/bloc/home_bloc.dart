import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define los eventos que el BLoC manejará
abstract class HomeEvent {}

class ChangeSelectedIndex extends HomeEvent {
  final int index;

  ChangeSelectedIndex(this.index);
}

// Define los estados que el BLoC emitirá
abstract class HomeState {
  final int selectedIndex;

  HomeState(this.selectedIndex);
}

class HomeInitialState extends HomeState {
  HomeInitialState() : super(0);
}

class HomeSelectedIndexChanged extends HomeState {
  HomeSelectedIndexChanged(int selectedIndex) : super(selectedIndex);
}

// Define el BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<ChangeSelectedIndex>((event, emit) {
      emit(HomeSelectedIndexChanged(event.index));
    });
  }

  
  Stream<HomeState> mapEventToState(HomeEvent event) async* {}
}
