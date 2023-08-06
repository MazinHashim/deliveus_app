import 'package:deleveus_app/order/order.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapConfirmCard extends StatelessWidget {
  const MapConfirmCard({
    required this.title,
    required this.description,
    required this.position,
    required this.image,
    required this.onTap,
    super.key,
  });
  final String title;
  final String description;
  final LatLng position;
  final VoidCallback onTap;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 21,
            color: Colors.grey,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 4,
                child: Text(description),
              ),
              const Spacer(),
              Flexible(
                child: Image.asset(image, width: 60),
              ),
            ],
          ),
          const Spacer(),
          BlocSelector<OrderBloc, OrderState, Order>(
            selector: (state) => state.order,
            builder: (context, order) {
              if (order.destinationLat != position.latitude &&
                  order.destinationLong != position.longitude) {
                return const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Please confirm the location you selected',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              child: const Text(
                'Confirm The Location',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
