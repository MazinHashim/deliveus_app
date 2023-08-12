import 'package:deleveus_app/food_details/food_details.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';

class FoodListTile extends StatelessWidget {
  const FoodListTile({
    required this.food,
    required this.orderBloc,
    super.key,
  });

  final OrderBloc orderBloc;
  final Food food;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder<FoodDetailsPage>(
              transitionDuration: const Duration(seconds: 2),
              pageBuilder: (context, a, b) {
                return FoodDetailsPage(
                  food: food,
                  orderBloc: orderBloc,
                );
              },
            ),
          );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: food.id,
                child: Image.network(food.photo!),
              ),
            ),
            Positioned(
              left: 0,
              top: 20,
              child: Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(1),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  '${l10n.rialText} ${food.price!.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight.withOpacity(0.7),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Text(
                  food.name!,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
