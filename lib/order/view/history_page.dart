import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/bloc/order_bloc.dart';
import 'package:deleveus_app/order/view/order_details.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(l10n.orderHidtoryTitle),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.prevOrders.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            itemCount: state.prevOrders.length,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            itemBuilder: (context, index) {
              final order = state.prevOrders[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('ORDER #${order.orderNumber}'),
                      contentPadding: EdgeInsets.zero,
                      subtitle: Text(
                        DateFormat('d MMM yyyy h:mm:ss a')
                            .format(order.orderDate!),
                      ),
                      trailing: Text(
                        order.status.toString().split('.')[1].capitalize(),
                        style: TextStyle(
                          color: order.status!.toColor(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${order.orderItems!.length} items'),
                        RichText(
                          text: TextSpan(
                            text:
                                '${(order.amount! + order.taxFee! + order.deliveryFee!).toStringAsFixed(2)} ',
                            style: DefaultTextStyle.of(context).style.copyWith(
                                  fontSize: 30,
                                ),
                            children: <TextSpan>[
                              TextSpan(
                                text: l10n.rialText,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            order.orderItems!
                                .map(
                                  (item) =>
                                      '${item.title!} x ${item.quantity} ',
                                )
                                .toString(),
                            softWrap: true,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 80,
                          child: OutlinedButton(
                            style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.all(4)),
                              shape: MaterialStatePropertyAll(StadiumBorder()),
                              iconSize: MaterialStatePropertyAll(17),
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<OrderDetails>(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<OrderBloc>(),
                                    child: OrderDetails(
                                      order: order,
                                      orderBloc: context.read<OrderBloc>(),
                                      history: true,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

extension OrderStatusColor on OrderStatus {
  Color toColor() {
    return switch (this) {
      OrderStatus.ordered => Colors.green,
      OrderStatus.processing => Colors.amber,
      OrderStatus.shipped => Colors.blue,
      OrderStatus.received => Colors.green,
      OrderStatus.failure => Colors.red,
      _ => Colors.black,
    };
  }
}

extension OrderQuantityIcon on OrderItem {
  IconData toIcon() {
    return switch (quantity) {
      1 => Icons.looks_one_rounded,
      2 => Icons.looks_two_rounded,
      3 => Icons.looks_3_rounded,
      4 => Icons.looks_4_rounded,
      5 => Icons.looks_5_rounded,
      6 => Icons.looks_6_rounded,
      _ => Icons.onetwothree_rounded,
    };
  }
}
