import 'package:deleveus_app/delivery/delivery.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:deleveus_app/utils/utils.dart';
import 'package:deleveus_app/widgets/widgets.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';

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
    var ord = order;
    if (order.orderNumber == null) {
      final orderNumber = context
          .select<OrderBloc, int?>((value) => value.state.order.orderNumber);
      ord = order.copyWith(
        address: order.address,
        destinationLat: order.destinationLat,
        destinationLong: order.destinationLong,
        fromBranch: order.fromBranch,
        cookingTime: order.cookingTime,
        orderingTime: order.orderingTime,
        deliveringTime: order.deliveringTime,
        orderNumber: orderNumber,
      );
    }

    return AppPageWidget(
      title: l10n.orderDetailsTitle,
      space: 15,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          children: [
            ListTile(
              title: Text(
                '${l10n.orderText} ${ord.orderNumber != null ? '#${ord.orderNumber}' : ''}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              subtitle: Text(
                DateFormat('d-MMM-yyyy h:mm:ss a').format(ord.orderDate!),
              ),
              trailing: Text(
                ord.status!.toName(l10n).capitalize(),
                style: TextStyle(
                  color: ord.status!.toColor(),
                  fontSize: 23,
                ),
              ),
            ),
            ListTile(
              title: Text(
                ord.fromBranch != null
                    ? l10n.pickupFromBranchText
                    : l10n.deliverToDestinationText,
              ),
              contentPadding: EdgeInsets.zero,
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              subtitle: ord.fromBranch != null
                  ? Text('${ord.fromBranch}')
                  : Text(
                      '${ord.address}',
                    ),
              trailing: const Icon(Icons.delivery_dining_sharp),
            ),
            ListTile(
              title: Text(l10n.paymentMethodText),
              contentPadding: EdgeInsets.zero,
              subtitle: const Text('Apple Pay'),
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              trailing: const Icon(Icons.payment_rounded),
            ),
            ...[
              ...ord.orderItems!.map(
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
                  Text(
                    l10n.subtotalText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  RichWidget(
                    text: '${ord.amount!.toStringAsFixed(2)} ',
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
                  Text(l10n.taxVATText),
                  RichWidget(
                    text: '${ord.taxFee!.toStringAsFixed(2)} ',
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
                  Text(l10n.deliveryChargeText),
                  RichWidget(
                    text: '${ord.deliveryFee!.toStringAsFixed(2)} ',
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
                  Text(
                    l10n.totalText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  RichWidget(
                    text:
                        '${(ord.amount! + ord.deliveryFee! + ord.taxFee!).toStringAsFixed(2)} ',
                    subtext: l10n.rialText,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ],
              ),
            ),
            // const Spacer(),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                final activeOrder = getActiveOrder(state.prevOrders);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 40,
                      ),
                      elevation: 4,
                      shape: const StadiumBorder(),
                      shadowColor: Colors.black,
                      child: ListTile(
                        trailing: const Icon(Icons.directions_rounded),
                        title: selectNewOrderDestination(state.order, l10n),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (activeOrder != null)
                      ActiveOrder(activeOrder, orderBloc)
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
                                    confirmOrder = ord.copyWith(
                                      orderDate: DateTime.now(),
                                      status: OrderStatus.ordering,
                                      destinationLat:
                                          state.order.destinationLat,
                                      destinationLong:
                                          state.order.destinationLong,
                                      address: state.order.address,
                                      fromBranch: state.order.fromBranch,
                                    );
                                  }
                                  context.read<OrderBloc>().add(
                                        OrderFoodForCustomerEvent(
                                          order: confirmOrder,
                                        ),
                                      );
                                },
                          child: Text(
                            history
                                ? l10n.reorderText
                                : l10n.confirmOrderingText,
                          ),
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
