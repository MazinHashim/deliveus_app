import 'dart:async';

import 'package:deleveus_app/delivery/delivery.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:deleveus_app/widgets/custom_error_widget.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryPage extends StatelessWidget {
  DeliveryPage({required this.orderBloc, super.key});

  final _deliveryRepository = DeliveryRepository();
  final OrderBloc orderBloc;

  @override
  Widget build(BuildContext context) {
    final deliveryBloc = DeliveryBloc(_deliveryRepository);
    return RepositoryProvider(
      create: (context) => _deliveryRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => deliveryBloc),
          BlocProvider.value(value: orderBloc)
        ],
        child: const DeliveryView(),
      ),
    );
  }
}

class DeliveryView extends StatefulWidget {
  const DeliveryView({super.key});

  @override
  State<DeliveryView> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  var _controller = Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Options'),
        centerTitle: true,
      ),
      body: BlocConsumer<DeliveryBloc, DeliveryState>(
        listener: (context, state) async {
          if (state.orderOption == OrderOption.pickup) {
            _controller = Completer<GoogleMapController>();
          }
        },
        builder: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomErrorWidget(errorMessage: state.errorMessage),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  label: const Text(
                    'Refresh',
                    style: TextStyle(fontSize: 17),
                  ),
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _controller = Completer<GoogleMapController>();
                    context
                        .read<DeliveryBloc>()
                        .add(const LoadGeolocationEvent());
                  },
                )
              ],
            );
          }
          // if (state.position == null) {
          //   return const Center(
          //     child: Text('Accessing Device Location...'),
          //   );
          // }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildOrderOptionTab(
                      OrderOption.delivery,
                      context,
                      state.orderOption,
                    ),
                    const SizedBox(width: 10),
                    buildOrderOptionTab(
                      OrderOption.pickup,
                      context,
                      state.orderOption,
                    ),
                  ],
                ),
              ),
              if (state.orderOption == OrderOption.delivery &&
                  state.position != null)
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: state.position!,
                          zoom: 8.5,
                        ),
                        onTap: (position) {
                          context
                              .read<DeliveryBloc>()
                              .add(ChangeSelectedLocationEvent(position));
                        },
                        markers: {
                          Marker(
                            markerId: MarkerId(state.currentMarker!.id),
                            position: state.currentMarker!.position,
                            icon: state.currentMarker!.icon,
                          )
                        },
                        onMapCreated: _controller.complete,
                      ),
                      buildConfirmationCard(state, context),
                      buildCurrentLocationButton(state, context),
                      if (state.loadingLocation) buildMapLoading(),
                    ],
                  ),
                )
              else if (state.orderOption == OrderOption.pickup &&
                  state.branches.isNotEmpty)
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: state.position!,
                          zoom: 8.5,
                        ),
                        onTap: (position) {
                          context
                              .read<DeliveryBloc>()
                              .add(const ToggleBottomPillEvent(-220));
                        },
                        markers: state.branches.map((branchMarker) {
                          return Marker(
                            markerId: MarkerId(branchMarker.id),
                            position: branchMarker.position,
                            icon: branchMarker.icon,
                            onTap: () {
                              context.read<DeliveryBloc>().add(
                                    ChangeSelectedBranchEvent(branchMarker.id),
                                  );
                              context
                                  .read<DeliveryBloc>()
                                  .add(const ToggleBottomPillEvent(20));
                            },
                          );
                        }).toSet(),
                        onMapCreated: _controller.complete,
                      ),
                      AnimatedPositioned(
                        duration: 500.ms,
                        curve: Curves.easeInOut,
                        bottom: state.pinPillPosition,
                        left: 20,
                        right: 20,
                        child: MapConfirmBranchCard(
                          branch: state.branches[0].branch!,
                          image: 'assets/imgs/rest-pin.png',
                          onTap: () {
                            context.read<OrderBloc>().add(
                                  ConfirmPickupBranchEvent(
                                    branchId: state.branches[0].id,
                                  ),
                                );
                          },
                        ),
                      ),
                      if (state.loadingBranches) buildMapLoading()
                    ],
                  ),
                )
              else
                Center(
                  child: Text('Cannot Access ${state.orderOption.name} Data'),
                )
            ],
          );
        },
      ),
    );
  }

  Positioned buildConfirmationCard(DeliveryState state, BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: MapConfirmCard(
        title: 'Delivery Checker',
        position: state.position!,
        description:
            'Click on the map to identify your destination and then confirm it',
        image: 'assets/imgs/location.png',
        onTap: () {
          context.read<OrderBloc>().add(
                ConfirmDestinationLocationEvent(
                  destination: state.position!,
                ),
              );
        },
      ),
    );
  }

  SizedBox buildCurrentLocationButton(
    DeliveryState state,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: state.loadingLocation
            ? null
            : () async {
                context.read<DeliveryBloc>().add(const LoadGeolocationEvent());
                await _goToTheLake(state.position!);
              },
        label: const Text(
          'Select My Current Location',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        icon: const Icon(Icons.place),
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.all(15),
          ),
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).primaryColor.withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  Container buildMapLoading() {
    return Container(
      decoration: const BoxDecoration(color: Colors.black26),
      child: const Center(
        child: Text(
          'Loading...',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _goToTheLake(LatLng latLng) async {
    await _controller.future.then((controller) async {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 18.4746,
          ),
        ),
      );
    });
  }

  Expanded buildOrderOptionTab(
    OrderOption option,
    BuildContext context,
    OrderOption selectedTap,
  ) {
    return Expanded(
      child: TextButton(
        style: selectedTap == option
            ? ButtonStyle(
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.all(10),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).primaryColorLight.withOpacity(0.7),
                ),
              )
            : null,
        child: Text(
          option.name.capitalize(),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).primaryColor,
          ),
        ),
        onPressed: () {
          context.read<DeliveryBloc>().add(
                OrderOptionChangedEvent(option),
              );
        },
      ),
    );
  }
}
