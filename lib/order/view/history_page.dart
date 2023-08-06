import 'package:deleveus_app/order/bloc/order_bloc.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order History'),
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

              return ExpansionTile(
                title: const Text('ORDER #2643'),
                subtitle: Text(order.orderDate.toString()),
                trailing: Text(
                  order.status.toString().split('.')[1].capitalize(),
                  style: TextStyle(
                    color: order.status!.toColor(),
                  ),
                ),
                expandedAlignment: Alignment.topLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                childrenPadding: const EdgeInsets.all(15),
                children: [
                  ...[
                    ...order.orderItems!.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.title!),
                            Text('${item.price!.toStringAsFixed(2)} SAR'),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const Divider(color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${order.amount!.toStringAsFixed(2)} SAR',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
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
