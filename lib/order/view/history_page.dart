import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/bloc/order_bloc.dart';
import 'package:deleveus_app/order/view/order_details.dart';
import 'package:deleveus_app/utils/utils.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';

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
          if (state.prevOrders == null) {
            return const Center(child: Text('No Orders In The History'));
          }
          if (state.prevOrders!.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: state.prevOrders!.length,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            itemBuilder: (context, index) {
              final order = state.prevOrders![index];

              final itemsStr = order.orderItems!
                  .map((item) => '${item.title!} x ${item.quantity} ')
                  .toString();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('${l10n.orderText} #${order.orderNumber}'),
                      contentPadding: EdgeInsets.zero,
                      subtitle: Text(
                        DateFormat('d MMM yyyy h:mm:ss a')
                            .format(order.orderDate!),
                      ),
                      trailing: Text(
                        order.status!.toName(l10n).capitalize(),
                        style: TextStyle(
                          color: order.status!.toColor(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${order.orderItems!.length} ${l10n.itemsCountText}'),
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
                            itemsStr.substring(1, itemsStr.length - 1),
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
