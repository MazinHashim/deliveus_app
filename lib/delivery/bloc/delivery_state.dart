part of 'delivery_bloc.dart';

enum OrderOption { delivery, pickup }

class DeliveryState extends Equatable {
  const DeliveryState({
    this.position,
    this.loadingLocation = true,
    this.loadingBranches = false,
    this.currentMarker,
    this.pinPillPosition = 20,
    this.branches = const [],
    this.orderOption = OrderOption.delivery,
    this.errorMessage = '',
  });

  final OrderOption orderOption;
  final LatLng? position;
  final double pinPillPosition;
  final List<MarkerInfo> branches;
  final MarkerInfo? currentMarker;
  final bool loadingLocation;
  final bool loadingBranches;
  final String errorMessage;

  DeliveryState copyWith({
    OrderOption? orderOption,
    LatLng? position,
    double? pinPillPosition,
    MarkerInfo? currentMarker,
    List<MarkerInfo>? branches,
    bool? loadingLocation,
    bool? loadingBranches,
    String? errorMessage,
  }) {
    return DeliveryState(
      orderOption: orderOption ?? this.orderOption,
      position: position ?? this.position,
      currentMarker: currentMarker ?? this.currentMarker,
      errorMessage: errorMessage ?? this.errorMessage,
      branches: branches ?? this.branches,
      loadingLocation: loadingLocation ?? this.loadingLocation,
      loadingBranches: loadingBranches ?? this.loadingBranches,
      pinPillPosition: pinPillPosition ?? this.pinPillPosition,
    );
  }

  @override
  List<Object?> get props => [
        orderOption,
        position,
        loadingBranches,
        loadingLocation,
        branches,
        pinPillPosition,
        currentMarker,
        errorMessage,
      ];
}

class MarkerInfo extends Equatable {
  const MarkerInfo({
    required this.id,
    required this.icon,
    required this.position,
    this.branch,
  });
  final String id;
  final LatLng position;
  final Branch? branch;
  final BitmapDescriptor icon;

  MarkerInfo copyWith({
    String? id,
    BitmapDescriptor? icon,
    LatLng? position,
    Branch? branch,
  }) {
    return MarkerInfo(
      id: id ?? this.id,
      position: position ?? this.position,
      icon: icon ?? this.icon,
      branch: branch ?? this.branch,
    );
  }

  @override
  List<Object?> get props => [id, icon, position, branch];
}
