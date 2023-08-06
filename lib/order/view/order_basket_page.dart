import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:deleveus_app/widgets/delivery_options_sheet.dart';
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
    return Scaffold(
      body: BlocProvider.value(
        value: orderBloc,
        child: const OrderBasketView(),
      ),
    );
  }
}

class OrderBasketView extends StatelessWidget {
  const OrderBasketView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Divider(),
          const AppTitle(title: 'Basket', icon: Icons.shopping_cart_rounded),
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
                // if (state.order.status == OrderStatus.progressing) {
                //   return const Center(
                //     child: CircularProgressIndicator(strokeWidth: 1),
                //   );
                // } else {
                return Center(
                  heightFactor: 32,
                  child: Text(
                    'No items in the basket', //"l10n.foodEmptyListText",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
                // }
              }
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
                        icon: const Icon(Icons.remove_circle_rounded),
                        label: const Text('Clear Items'),
                      ),
                    ),
                    const Spacer(),
                    if (state.order.destinationLat != null &&
                        state.order.destinationLong != null)
                      Flexible(
                        child: Text(
                            '${state.order.destinationLat} ${state.order.destinationLong}'),
                      ),
                    if (state.order.fromBranch != null)
                      Flexible(child: Text('${state.order.fromBranch}')),
                    Flexible(
                      child: buildOrderNowButton(
                        state.totalAmount,
                        (state.order.fromBranch == null &&
                                (state.order.destinationLat == null &&
                                    state.order.destinationLong == null))
                            ? () {
                                showModalBottomSheet<DeliveryOptionsSheet>(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => const DeliveryOptionsSheet(),
                                );
                              }
                            : state.order.status == OrderStatus.progressing
                                ? null
                                : () {
                                    final order = state.order.copyWith(
                                      amount: state.totalAmount,
                                      orderDate: DateTime.now(),
                                      orderItems: state.orderItems,
                                      status: OrderStatus.ordered,
                                      userId:
                                          context.read<AppBloc>().state.user.id,
                                    );
                                    context.read<OrderBloc>().add(
                                          OrderFoodForCustomerEvent(
                                            order: order,
                                          ),
                                        );
                                    // Navigator.of(context).push(OrderDetails);
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
                      '${orderItem.title} removed from the basket',
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
                'SAR ${orderItem.price!.toStringAsFixed(2)}',
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox buildOrderNowButton(double totalAmount, VoidCallback? onTap) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ORDER NOW',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'SAR ${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
