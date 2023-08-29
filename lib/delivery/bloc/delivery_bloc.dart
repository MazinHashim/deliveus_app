import 'dart:async';

import 'package:delivery_repository/delivery_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'delivery_event.dart';
part 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  DeliveryBloc(this._deliveryRepository) : super(const DeliveryState()) {
    on<OrderOptionChangedEvent>(_changeOrderOption);
    on<LoadGeolocationEvent>(_fetchCurrentLocation);
    on<LoadBranchesDataEvent>(_fetchBranchesData);
    on<ChangeSelectedLocationEvent>(_selectDestinationLocation);
    on<ChangeSelectedBranchEvent>(_selectBranchLocation);
    on<ToggleBottomPillEvent>(_toggleBottomPill);

    on<AddErrorMessageEvent>((event, emit) {
      emit(state.copyWith(errorMessage: event.message));
    });
    on<ClearDeliveryErrorMessageEvent>((event, emit) {
      emit(state.copyWith(errorMessage: ''));
    });

    add(const OrderOptionChangedEvent(OrderOption.delivery));
  }

  final DeliveryRepository _deliveryRepository;

  void _changeOrderOption(
    OrderOptionChangedEvent event,
    Emitter<DeliveryState> emit,
  ) {
    emit(state.copyWith(orderOption: event.orderOption));
    if (event.orderOption == OrderOption.delivery) {
      add(const LoadGeolocationEvent());
    } else {
      add(const LoadBranchesDataEvent());
    }
  }

  Future<void> _fetchCurrentLocation(
    LoadGeolocationEvent event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(state.copyWith(loadingLocation: true, errorMessage: ''));
    try {
      await _deliveryRepository
          .getCurrentLocation()
          .onError((error, stackTrace) {
        throw DeliveryFailure(error.toString());
      }).then((position) async {
        const imgsrc = 'assets/imgs/current_location.png';
        final markerbitmap = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration.empty,
          imgsrc,
        ).onError((error, stackTrace) {
          throw DeliveryFailure(error.toString());
        });
        final latLong = LatLng(position.latitude, position.longitude);
        final placemark = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        final address =
            '${placemark.first.locality}, ${placemark.first.subLocality}, ${placemark.first.thoroughfare}';
        emit(
          state.copyWith(
            position: latLong,
            address: address,
            loadingLocation: false,
            currentMarker: MarkerInfo(
              id: 'current',
              position: latLong,
              icon: markerbitmap,
            ),
          ),
        );
      });
    } on DeliveryFailure catch (e) {
      add(AddErrorMessageEvent(e.message));
    }
  }

  Future<void> _fetchBranchesData(
    LoadBranchesDataEvent event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(state.copyWith(loadingBranches: true));
    const imgsrc = 'assets/imgs/branch_marker.png';
    final markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      imgsrc,
    );

    await emit.forEach<List<Branch>>(
      _deliveryRepository.getBranches(),
      onData: (branches) {
        final branchesMarkers = branches.map((branch) {
          return MarkerInfo(
            id: branch.id,
            icon: markerbitmap,
            branch: branch,
            position: LatLng(branch.lat!, branch.long!),
          );
        }).toList();
        return state.copyWith(
          loadingBranches: false,
          position:
              branchesMarkers.isNotEmpty ? branchesMarkers[0].position : null,
          branches: branchesMarkers,
        );
      },
      onError: (e, __) => state.copyWith(
        errorMessage: e.toString(),
      ),
    );
  }

  Future<void> _selectDestinationLocation(
    ChangeSelectedLocationEvent event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(state.copyWith(loadingLocation: true));
    const imgsrc = 'assets/imgs/current_location.png';
    final markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      imgsrc,
    );

    final placemark = await placemarkFromCoordinates(
      event.position.latitude,
      event.position.longitude,
    );
    final address =
        '${placemark.first.locality},${placemark.first.subLocality},${placemark.first.thoroughfare}';
    emit(
      state.copyWith(
        loadingLocation: false,
        address: address,
        currentMarker: MarkerInfo(
          id: 'current',
          position: event.position,
          icon: markerbitmap,
        ),
      ),
    );
  }

  void _selectBranchLocation(
    ChangeSelectedBranchEvent event,
    Emitter<DeliveryState> emit,
  ) {
    final index =
        state.branches.indexWhere((branch) => branch.id == event.branchId);
    state.branches.insert(0, state.branches[index]);
    state.branches.removeAt(index + 1);
    final brs = state.branches;
    emit(
      state.copyWith(position: brs[0].position, branches: brs),
    );
  }

  void _toggleBottomPill(
    ToggleBottomPillEvent event,
    Emitter<DeliveryState> emit,
  ) {
    emit(state.copyWith(pinPillPosition: event.value));
  }
}
