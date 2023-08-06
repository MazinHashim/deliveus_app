import 'package:flutter/material.dart';

class DeliveryOptionsSheet extends StatelessWidget {
  const DeliveryOptionsSheet({super.key});

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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
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
                isSelected: true,
              ),
              const SizedBox(width: 20),
              buildAppDeliveryOption(context, 'Pickup from a restaurant'),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }

  Expanded buildAppDeliveryOption(
    BuildContext context,
    String title, {
    bool isSelected = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: isSelected ? null : () {},
        child: Container(
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
