import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:delivery_repository/delivery_repository.dart' show Branch;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:intl/intl.dart';

class MapConfirmBranchCard extends StatelessWidget {
  const MapConfirmBranchCard({
    required this.branch,
    required this.image,
    required this.onTap,
    super.key,
  });
  final Branch branch;
  final VoidCallback onTap;
  final String image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final closingTime = branch.closingTime!.subtract(
      Duration(
        days: branch.closingTime!.difference(branch.openingTime!).inDays,
      ),
    );
    final isOpen = DateTime.now().isAfter(branch.openingTime!) &&
        DateTime.now().isAfter(closingTime);

    return Container(
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 21,
            color: Colors.grey,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      branch.name!.capitalize(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isOpen ? l10n.openNowText : l10n.closedBranchText,
                      style: TextStyle(
                        color: isOpen ? Colors.green : Colors.red,
                      ),
                    ),
                    const Spacer(),
                    Text(
                        '${branch.distance!.toStringAsFixed(0)} ${l10n.kmUnitText}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Text(branch.address!),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Image.asset(image, width: 60),
                    ),
                  ],
                ),
                Text(
                    '${l10n.openingTimeText} : ${DateFormat('h:mm a').format(branch.openingTime!)} - ${DateFormat('h:mm a').format(branch.closingTime!)}'),
              ],
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: BlocSelector<OrderBloc, OrderState, String>(
              selector: (state) => state.order.fromBranch ?? '',
              builder: (context, confirmedBranchId) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${l10n.estimatedTimeText} : ${branch.prepareTime!}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    if (confirmedBranchId.isEmpty ||
                        confirmedBranchId != branch.id)
                      InkWell(
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 15,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                l10n.confirmBranchButtonText,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
