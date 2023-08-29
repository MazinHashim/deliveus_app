import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/delivery/delivery.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:deleveus_app/utils/utils.dart';
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
    return AppPageWidget(
      title: l10n.basketTitle,
      child: BlocConsumer<OrderBloc, OrderState>(
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
            context.read<OrderBloc>().add(const ClearOrderErrorMessageEvent());
          }
        },
        builder: (context, state) {
          if (state.orderItems.isEmpty) {
            return Center(
              child: Text(l10n.orderItemEmptyListText),
            );
          }
          final activeOrder = getActiveOrder(state.prevOrders);
          return Column(
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
                    context.read<OrderBloc>().add(const ClearOrderItemsEvent());
                  },
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                  label: Text(l10n.clearItemsButton),
                ),
              ),
              const Spacer(),
              Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                elevation: 4,
                shape: const StadiumBorder(),
                shadowColor: Colors.black,
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<DeliveryPage>(
                        builder: (context) =>
                            DeliveryPage(orderBloc: orderBloc),
                      ),
                    );
                  },
                  trailing: const Icon(Icons.directions_rounded),
                  title: selectNewOrderDestination(state.order, l10n),
                ),
              ),
              if (activeOrder != null)
                ActiveOrder(activeOrder, orderBloc)
              else
                Flexible(
                  child: buildOrderNowButton(
                    l10n,
                    state.totalAmount,
                    (state.order.fromBranch == null &&
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
                        : state.order.status == OrderStatus.progressing
                            ? null
                            : () {
                                final taxFee = state.totalAmount * (15 / 100);
                                final order = state.order.copyWith(
                                  amount: state.totalAmount,
                                  orderDate: DateTime.now(),
                                  orderItems: state.orderItems,
                                  destinationLat: state.order.destinationLat,
                                  destinationLong: state.order.destinationLong,
                                  address: state.order.address,
                                  fromBranch: state.order.fromBranch,
                                  taxFee: taxFee,
                                  deliveryFee: 12,
                                  status: OrderStatus.ordering,
                                  userId: context.read<AppBloc>().state.user.id,
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
              const SizedBox(height: 10),
            ],
          );
        },
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
    AppLocalizations l10n,
    double totalAmount,
    VoidCallback? onTap,
  ) {
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
