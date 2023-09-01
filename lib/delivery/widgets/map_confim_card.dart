import 'package:deleveus_app/l10n/l10n.dart';
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
    required this.address,
    required this.image,
    required this.onTap,
    super.key,
  });
  final String title;
  final String description;
  final String address;
  final LatLng position;
  final VoidCallback onTap;
  final String image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      height: MediaQuery.of(context).size.height / 3.3,
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
              // const Spacer(),
              Flexible(
                child: Image.asset(image, width: 60),
              ),
            ],
          ),
          BlocSelector<OrderBloc, OrderState, Order>(
            selector: (state) => state.order,
            builder: (context, order) {
              if (order.destinationLat != position.latitude &&
                  order.destinationLong != position.longitude) {
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.confirmLocationMessageText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.green),
                      ),
                      Text(
                        address,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              child: Text(
                l10n.confirmLocationButtonText,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
