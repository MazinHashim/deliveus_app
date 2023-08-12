import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';

class ActiveOrder extends StatelessWidget {
  const ActiveOrder(this.order, {super.key});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 5,
        color: Colors.green[50],
        margin: const EdgeInsets.all(7),
        child: ListTile(
          onTap: () {
            // navigate to order tracker widget
          },
          minLeadingWidth: 0,
          title: Text('Order #${order.orderNumber} is active'),
          subtitle: order.fromBranch != null
              ? Text('${l10n.pickupFromBranchText} ${order.fromBranch}')
              : Text(
                  '${l10n.deliverToDestinationText} ${order.destinationLat} ${order.destinationLong}'),
          trailing: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: order.status!.toColor().withOpacity(0.5),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 3, strokeAlign: 4),
            ),
            child: Text(
              order.status.toString().split('.')[1].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
