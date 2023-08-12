import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/delivery/delivery.dart';
import 'package:deleveus_app/home/widgets/acitve_order_widget.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:deleveus_app/order/view/order_details.dart';
import 'package:deleveus_app/widgets/widgets.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBasketPage extends StatelessWidget {
  const OrderBasketPage({
    required this.orderBloc,
    required this.appBloc,
    super.key,
  });

  final OrderBloc orderBloc;
  final AppBloc appBloc;
  @override
  Widget build(BuildContext context) {
    // print(Directionality.of(context).name);
    return BlocProvider.value(
      value: orderBloc,
      child: Scaffold(
        body: OrderBasketView(orderBloc: orderBloc),
      ),
    );
  }
}

class OrderBasketView extends StatelessWidget {
  const OrderBasketView({
    required this.orderBloc,
    super.key,
  });

  final OrderBloc orderBloc;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Column(
        children: [
          const Divider(),
          AppTitle(title: l10n.basketTitle, icon: Icons.shopping_cart_rounded),
          const Divider(),
          const SizedBox(height: 20),
          BlocConsumer<OrderBloc, OrderState>(
            // listenWhen: (previous, current) => current.,
            listener: (context, state) {
              context.read<OrderBloc>().add(const ComputeTotalAmountEvent());
              if (state.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                    ),
                  );
                context
                    .read<OrderBloc>()
                    .add(const ClearOrderErrorMessageEvent());
              }
            },
            builder: (context, state) {
              if (state.orderItems.isEmpty) {
                return Center(
                  child: Text(l10n.orderItemEmptyListText),
                );
              }
              final currentActiveOrder = state.prevOrders.where(
                (order) =>
                    order.status != OrderStatus.received &&
                    order.status != OrderStatus.failure,
              );
              return Expanded(
                child: Column(
                  children: [
                    Flexible(
                      flex: 8,
                      child: buildItemListTileWidget(
                        state.orderItems,
                        context.read<OrderBloc>(),
                        state.errorMessage,
                      ),
                    ),
                    Flexible(
                      child: TextButton.icon(
                        style: const ButtonStyle(
                          iconColor: MaterialStatePropertyAll(Colors.red),
                          foregroundColor: MaterialStatePropertyAll(Colors.red),
                        ),
                        onPressed: () {
                          context
                              .read<OrderBloc>()
                              .add(const ClearOrderItemsEvent());
                        },
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        label: Text(l10n.clearItemsButton),
                      ),
                    ),
                    const Spacer(),
                    if (state.order.destinationLat != null &&
                        state.order.destinationLong != null)
                      Flexible(
                        child: Text(
                            '${l10n.deliverToDestinationText} ${state.order.destinationLat} ${state.order.destinationLong}'),
                      ),
                    if (state.order.fromBranch != null)
                      Flexible(
                        child: Text(
                          '${l10n.pickupFromBranchText} ${state.order.fromBranch}',
                        ),
                      ),
                    if (currentActiveOrder.isNotEmpty)
                      ActiveOrder(currentActiveOrder.first)
                    else
                      Flexible(
                        child: buildOrderNowButton(
                          l10n,
                          state.totalAmount,
                          (state.order.fromBranch == null &&
                                  (state.order.destinationLat == null &&
                                      state.order.destinationLong == null))
                              ? () {
                                  // showModalBottomSheet<DeliveryPage>(
                                  //   context: context,
                                  //   backgroundColor: Colors.transparent,
                                  //   isScrollControlled: true,
                                  //   showDragHandle: true,
                                  //   builder: (_) => Padding(
                                  //    padding: const EdgeInsets.only(top: 20),
                                  //    child: DeliveryPage(orderBloc: orderBloc),
                                  //   ),
                                  // );
                                  Navigator.of(context).push(
                                    MaterialPageRoute<DeliveryPage>(
                                      builder: (context) =>
                                          DeliveryPage(orderBloc: orderBloc),
                                    ),
                                  );
                                  //showModalBottomSheet<DeliveryOptionsSheet>(
                                  //context: context,
                                  //backgroundColor: Colors.transparent,
                                  //builder: (_) => const DeliveryOptionsSheet(),
                                  //);
                                }
                              : state.order.status == OrderStatus.progressing
                                  ? null
                                  : () {
                                      final taxFee =
                                          state.totalAmount * (15 / 100);
                                      final order = state.order.copyWith(
                                        orderNumber: 1427,
                                        amount: state.totalAmount,
                                        orderDate: DateTime.now(),
                                        orderItems: state.orderItems,
                                        destinationLat:
                                            state.order.destinationLat,
                                        destinationLong:
                                            state.order.destinationLong,
                                        fromBranch: state.order.fromBranch,
                                        taxFee: taxFee,
                                        deliveryFee: 12,
                                        status: OrderStatus.ordered,
                                        userId: context
                                            .read<AppBloc>()
                                            .state
                                            .user
                                            .id,
                                      );

                                      Navigator.of(context).push(
                                        MaterialPageRoute<OrderDetails>(
                                          builder: (_) => BlocProvider.value(
                                            value: orderBloc,
                                            child: OrderDetails(
                                              order: order,
                                              orderBloc: orderBloc,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ListView buildItemListTileWidget(
    List<OrderItem> orderItems,
    OrderBloc orderBloc,
    String errorMessage,
  ) {
    return ListView.builder(
      itemCount: orderItems.length,
      itemBuilder: (context, index) {
        final orderItem = orderItems[index];
        final l10n = context.l10n;
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Dismissible(
            key: Key(orderItem.foodId),
            onDismissed: (direction) {
              context.read<OrderBloc>().add(
                    RemoveItemFromOrderEvent(
                      foodId: orderItem.foodId,
                    ),
                  );

              if (errorMessage.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    content: Text(
                      '${orderItem.title} ${l10n.successRemoveItem}',
                    ),
                  ),
                );
              }
            },
            direction: DismissDirection.startToEnd,
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8),
              color: Colors.red[100],
              child: const Icon(Icons.delete),
            ),
            child: ListTile(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute<FoodDetailsPage>(
                //     builder: (context) => FoodDetailsPage(
                //       food: orderItem.foodId,
                //       orderBloc: orderBloc,
                //     ),
                //   ),
                // );
              },
              tileColor: Theme.of(context).primaryColorLight.withOpacity(0.2),
              leading: Text(
                orderItem.quantity.toString(),
                style: const TextStyle(fontSize: 18),
              ),
              minLeadingWidth: 2,
              title: Text(orderItem.title!),
              trailing: Text(
                '${l10n.rialText} ${orderItem.price!.toStringAsFixed(2)}',
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox buildOrderNowButton(
      AppLocalizations l10n, double totalAmount, VoidCallback? onTap) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.orderNowButton,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              '${l10n.rialText} ${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
