import 'package:deleveus_app/delivery/delivery.dart';
import 'package:deleveus_app/home/widgets/acitve_order_widget.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    required this.order,
    required this.orderBloc,
    this.history = false,
    super.key,
  });
  final Order order;
  final OrderBloc orderBloc;
  final bool history;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'ORDER #${order.orderNumber}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              contentPadding: EdgeInsets.zero,
              subtitle: Text(
                DateFormat('d-MMM-yyyy h:mm:ss a').format(order.orderDate!),
              ),
              trailing: Text(
                order.status.toString().split('.')[1].capitalize(),
                style: TextStyle(color: order.status!.toColor(), fontSize: 23),
              ),
            ),
            ListTile(
              title: Text(
                order.fromBranch != null
                    ? l10n.pickupFromBranchText
                    : l10n.deliverToDestinationText,
              ),
              contentPadding: EdgeInsets.zero,
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              subtitle: order.fromBranch != null
                  ? Text('${order.fromBranch}')
                  : Text(
                      '${order.destinationLat} ${order.destinationLong} ${order.destinationLat} ${order.destinationLong}'),
              trailing: const Icon(Icons.delivery_dining_sharp),
            ),
            ListTile(
              title: const Text('Payment Method'),
              contentPadding: EdgeInsets.zero,
              subtitle: const Text('Apple Pay'),
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              trailing: const Icon(Icons.payment_rounded),
            ),
            ...[
              ...order.orderItems!.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.title!} x '),
                      Icon(
                        item.toIcon(),
                        color: Theme.of(context).primaryColorLight,
                      ),
                      const Spacer(),
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.titleLarge!,
                        child: RichWidget(
                          text:
                              '${(item.price! * item.quantity!).toStringAsFixed(2)} ',
                          subtext: l10n.rialText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  RichWidget(
                    text: '${order.amount!.toStringAsFixed(2)} ',
                    subtext: l10n.rialText,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tax (VAT) 15%'),
                  RichWidget(
                    text: '${order.taxFee!.toStringAsFixed(2)} ',
                    subtext: l10n.rialText,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Delivery charge'),
                  RichWidget(
                    text: '${order.deliveryFee!.toStringAsFixed(2)} ',
                    subtext: l10n.rialText,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  RichWidget(
                    text:
                        '${(order.amount! + order.deliveryFee! + order.taxFee!).toStringAsFixed(2)} ',
                    subtext: l10n.rialText,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ],
              ),
            ),
            const Spacer(),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                final currentActiveOrder = state.prevOrders.where(
                  (order) =>
                      order.status != OrderStatus.received &&
                      order.status != OrderStatus.failure,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.black,
                      child: ListTile(
                        trailing: const Icon(Icons.delivery_dining),
                        title: selectNewOrderDestination(state.order, l10n),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (currentActiveOrder.isNotEmpty)
                      ActiveOrder(currentActiveOrder.first)
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (state.order.fromBranch == null &&
                                  (state.order.destinationLat == null &&
                                      state.order.destinationLong == null))
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<DeliveryPage>(
                                      builder: (context) =>
                                          DeliveryPage(orderBloc: orderBloc),
                                    ),
                                  );
                                }
                              : () {
                                  var confirmOrder = order;
                                  if (history) {
                                    confirmOrder = order.copyWith(
                                      orderDate: DateTime.now(),
                                      orderNumber: 1428,
                                      status: OrderStatus.ordered,
                                      destinationLat:
                                          state.order.destinationLat,
                                      destinationLong:
                                          state.order.destinationLong,
                                      fromBranch: state.order.fromBranch,
                                    );
                                  }
                                  context.read<OrderBloc>().add(
                                        OrderFoodForCustomerEvent(
                                          order: confirmOrder,
                                        ),
                                      );
                                },
                          child: Text(history ? 'Re-order' : 'Confirm Order'),
                        ),
                      ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Text selectNewOrderDestination(Order order, AppLocalizations l10n) {
    if (order.fromBranch == null &&
        (order.destinationLat == null && order.destinationLong == null)) {
      return const Text('No Destination Selected');
    } else {
      if (order.fromBranch == null) {
        return Text(
            'New order ${l10n.deliverToDestinationText} ${order.destinationLat} ${order.destinationLong}');
      } else {
        return Text(
            'New order ${l10n.pickupFromBranchText} ${order.fromBranch}');
      }
    }
  }
}

class RichWidget extends StatelessWidget {
  const RichWidget({
    required this.text,
    required this.subtext,
    this.fontWeight,
    this.fontSize,
    super.key,
  });
  final String text;
  final String subtext;
  final FontWeight? fontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: fontSize ?? 15,
              fontWeight: fontWeight ?? FontWeight.normal,
            ),
        children: <TextSpan>[
          TextSpan(
            text: subtext,
            style: const TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }
}
