import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:event_find/models/map_marker.dart';
import 'package:event_find/repositories/map_marker_repository.dart';
import 'package:event_find/services/firebase_storage_service.dart';

abstract class MapEvent {
  const MapEvent();
}

class FetchMapMarkers extends MapEvent {}

class RequestUserLocation extends MapEvent {} 

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapMarkersLoaded extends MapState {
  final List<MapMarker> mapMarkers;

  const MapMarkersLoaded({required this.mapMarkers});

  @override
  List<Object> get props => [mapMarkers];
}

class UserLocationLoaded extends MapState { 
  final LatLng userLocation;

  const UserLocationLoaded({required this.userLocation});

  @override
  List<Object> get props => [userLocation];
}

class MapError extends MapState {
  final String errorMessage;

  const MapError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class MapBloc extends Bloc<MapEvent, MapState> {
  final FirebaseStorageService firebaseStorageService;
  final MapMarkerRepository mapMarkerRepository;
  final Location locationController = Location();
   

  MapBloc({required this.firebaseStorageService, required this.mapMarkerRepository}) : super(MapInitial()) {
    on<FetchMapMarkers>((event, emit) async {
      emit(MapLoading());
      try {
        List<MapMarker> mapMarkers = await mapMarkerRepository.fetchMapMarkers();
        emit(MapMarkersLoaded(mapMarkers: mapMarkers));
      } catch (e) {
        emit(MapError(errorMessage: e.toString()));
      }
    });

    on<RequestUserLocation>((event, emit) async {
      try {
        LatLng userLocation = await _getUserLocation();
        emit(UserLocationLoaded(userLocation: userLocation));
      //} on PermissionDeniedException catch (e) {
      //  emit(MapError(errorMessage: 'Permission denied: ${e.message}'));
      } on TimeoutException catch (e) {
        emit(MapError(errorMessage: 'Timeout: ${e.message}'));
      } on Exception catch (e) {
        emit(MapError(errorMessage: 'Unknown error occurred while getting user location: ${e.toString()}'));
      } 
    });
  }

  Future<LatLng> getUserLocation() async {
      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await locationController.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationController.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
      }

      permissionGranted = await locationController.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await locationController.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission denied.');
        }
      }

      locationData = await locationController.getLocation();
      return LatLng(locationData.latitude!, locationData.longitude!);
    }
  

  Future<LatLng> _getUserLocation() async {
    try {
      LocationData locationData = await locationController.getLocation();
      return LatLng(locationData.latitude!, locationData.longitude!);
    //} on PermissionDeniedException catch (e) {
    //  throw e;
    } on TimeoutException catch (e) {
      throw e;
    } catch (e) {
      throw Exception('Error getting location: ${e.toString()}');
    }
  }
}
