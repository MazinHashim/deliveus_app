import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:deleveus_app/utils/utils.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';

class ActiveOrder extends StatelessWidget {
  const ActiveOrder(this.order, this.orderBloc, {super.key});
  final Order order;
  final OrderBloc orderBloc;

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
            Navigator.of(context).push(
              MaterialPageRoute<OrderTracker>(
                builder: (_) => OrderTrackerPage(order, orderBloc),
              ),
            );
          },
          minLeadingWidth: 0,
          title: Text('${l10n.trackActiveOrderText} #${order.orderNumber}'),
          subtitle: order.fromBranch != null
              ? Text('${l10n.pickupFromBranchText} ${order.fromBranch}')
              : Text(
                  '${l10n.deliverToDestinationText} ${order.address}',
                ),
          trailing: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: order.status!.toColor().withOpacity(0.5),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 3, strokeAlign: 4),
            ),
            child: Text(
              order.status!.toName(l10n).toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
