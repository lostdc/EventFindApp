import 'package:event_find/models/map_marker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_find/repositories/map_marker_repository.dart';
import 'package:latlong2/latlong.dart';


class MapBloc extends Bloc<MapEvent, MapState> {

  final MapMarkerRepository _mapMarkerRepository;
  
  MapBloc({required MapMarkerRepository mapMarkerRepository})
      : _mapMarkerRepository = mapMarkerRepository,
        super(MapInitial());
  
  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is LoadMapMarkers) {
      yield* _mapMarkersToState();
    } else if (event is UpdateMyLocation) {
      yield* _myLocationToState(event.location);
    }
  }
  
  Stream<MapState> _mapMarkersToState() async* {
    yield MapLoading();
    try {
      final List<MapMarker> mapMarkers =
          await _mapMarkerRepository.fetchMapMarkers();
      yield MapLoaded(mapMarkers: mapMarkers);
    } catch (e) {
      yield MapError(message: e.toString());
    }
  }
  
  Stream<MapState> _myLocationToState(LatLng location) async* {
    yield MapLoaded(mapMarkers: state.mapMarkers, myLocation: location);
  }
}

abstract class MapEvent extends Equatable {
  const MapEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadMapMarkers extends MapEvent {}

class UpdateMyLocation extends MapEvent {
  final LatLng location;
  
  const UpdateMyLocation({required this.location});
  
  @override
  List<Object?> get props => [location];
}

abstract class MapState extends Equatable {
  const MapState();
  
  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<MapMarker> mapMarkers;
  final LatLng? myLocation;
  
  const MapLoaded({
    required this.mapMarkers,
    this.myLocation,
  });
  
  @override
  List<Object?> get props => [mapMarkers, myLocation];
}

class MapError extends MapState {
  final String message;
  
  const MapError({required this.message});
  
  @override
  List<Object?> get props => [message];
}


