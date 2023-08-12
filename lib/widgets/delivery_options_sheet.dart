import 'package:deleveus_app/delivery/delivery.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryOptionsSheet extends StatefulWidget {
  const DeliveryOptionsSheet({super.key});

  @override
  State<DeliveryOptionsSheet> createState() => _DeliveryOptionsSheetState();
}

class _DeliveryOptionsSheetState extends State<DeliveryOptionsSheet> {
  late OrderOption selectedOption = OrderOption.delivery;
  void selectOrderOption(OrderOption op) {
    setState(() {
      selectedOption = op;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(40),
        ),
        color: Theme.of(context).primaryColorLight,
      ),
      child: Column(
        children: [
          const Divider(
            color: Colors.white,
            height: 0,
            indent: 140,
            endIndent: 140,
            thickness: 1.7,
          ),
          const SizedBox(height: 20),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Options',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 10),
              buildAppDeliveryOption(
                context,
                'Deliver to an address',
                isSelected: selectedOption == OrderOption.delivery,
                onTap: () {
                  selectOrderOption(OrderOption.delivery);
                },
              ),
              const SizedBox(width: 20),
              buildAppDeliveryOption(
                context,
                'Pickup from a restaurant',
                isSelected: selectedOption == OrderOption.pickup,
                onTap: () {
                  selectOrderOption(OrderOption.pickup);
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<DeliveryPage>(
                    builder: (context) =>
                        DeliveryPage(orderBloc: context.read<OrderBloc>()),
                  ),
                );
              },
              child: Text('Choose a destination'.toUpperCase()),
            ),
          )
        ],
      ),
    );
  }

  Expanded buildAppDeliveryOption(
    BuildContext context,
    String title, {
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: isSelected ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
          height: MediaQuery.of(context).size.height / 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: !isSelected
                ? null
                : const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
            color:
                isSelected ? Colors.white : Theme.of(context).primaryColorLight,
          ),
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
