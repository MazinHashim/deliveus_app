import 'package:deleveus_app/order/order.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDetailsPage extends StatelessWidget {
  const FoodDetailsPage({
    required this.food,
    required this.orderBloc,
    super.key,
  });

  final Food food;
  final OrderBloc orderBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: orderBloc,
      child: FoodDetailsView(food: food),
    );
  }
}

class FoodDetailsView extends StatelessWidget {
  const FoodDetailsView({required this.food, super.key});

  final Food food;

  @override
  Widget build(BuildContext context) {
    var totalAmount = 0;
    for (final cal in food.calories!) {
      totalAmount += cal.amount!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name!),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildFoodDetailsImage(),
              const SizedBox(height: 20),
              buildDescriptionAndPriceText(),
              const SizedBox(height: 25),
              const Divider(),
              ExpansionTile(
                title: const Text('NUTRITIONAL INFORMATION'),
                tilePadding: EdgeInsets.zero,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColorLight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$totalAmount kcal', softWrap: true),
                      const Icon(Icons.keyboard_arrow_down_sharp)
                    ],
                  ),
                ),
                children: calories(),
              ),
              const Spacer(),
              const Divider(),
              BlocConsumer<OrderBloc, OrderState>(
                listener: (context, state) {
                  context
                      .read<OrderBloc>()
                      .add(const ComputeTotalAmountEvent());
                },
                builder: (context, state) {
                  final orderItem =
                      state.orderItems.where((item) => item.foodId == food.id);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          context
                              .read<OrderBloc>()
                              .add(const IncreaseItemQuantityEvent());
                        },
                        child: const Stack(
                          children: [
                            Icon(Icons.shopping_cart, size: 30),
                            Positioned(
                              top: 3,
                              right: 8,
                              child: Icon(
                                Icons.add,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: orderItem.isNotEmpty &&
                                orderItem.first.quantity == state.quantity
                            ? const Padding(
                                padding: EdgeInsets.all(13),
                                child: Text(
                                  'Quantity Added',
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  context.read<OrderBloc>().add(
                                        AddItemToOrderEvent(
                                          item: OrderItem(
                                            foodId: food.id,
                                            price: food.price,
                                            quantity: state.quantity,
                                            title: food.name,
                                          ),
                                        ),
                                      );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orderItem.isNotEmpty
                                          ? 'UPDATE ORDER'
                                          : 'ADD TO ORDER',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      state.quantity.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      InkWell(
                        onTap: () {
                          context
                              .read<OrderBloc>()
                              .add(const DecreaseItemQuantityEvent());
                        },
                        child: const Stack(
                          children: [
                            Icon(Icons.shopping_cart, size: 30),
                            Positioned(
                              top: 3,
                              right: 7,
                              child: Icon(
                                Icons.remove,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Row> calories() {
    return food.calories!.map((e) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(e.title!),
          Text('${e.amount} kcal'),
        ],
      );
    }).toList();
  }

  Row buildDescriptionAndPriceText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: Text(
            food.description!,
            softWrap: true,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const Spacer(),
        Flexible(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'SAR ${food.price!.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Container buildFoodDetailsImage() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(spreadRadius: 5, blurRadius: 15, color: Colors.grey),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Hero(
          tag: food.id,
          child: Image.network(
            food.photo!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
