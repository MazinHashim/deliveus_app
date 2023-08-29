import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:deleveus_app/utils/utils.dart';
import 'package:deleveus_app/widgets/widgets.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slide_countdown/slide_countdown.dart';

class OrderTrackerPage extends StatelessWidget {
  const OrderTrackerPage(this.order, this.orderBloc, {super.key});
  final OrderBloc orderBloc;
  final Order order;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: orderBloc,
      child: OrderTracker(order, orderBloc),
    );
  }
}

class OrderTracker extends StatefulWidget {
  const OrderTracker(this.order, this.orderBloc, {super.key});
  final OrderBloc orderBloc;
  final Order order;

  @override
  State<OrderTracker> createState() => _OrderTrackerState();
}

class _OrderTrackerState extends State<OrderTracker> {
  late int currentStep = -1;
  late StreamDuration _streamDuration;
  late Duration startCountAt = Duration.zero;
  late Future<SharedPreferences> futurelocalStorage =
      SharedPreferences.getInstance();
  late OrderStatus lastStatus = widget.order.status!;

  @override
  void initState() {
    super.initState();

    final statusStartAt = getPrevouisStatusPeriod(widget.order);
    startCountAt = DateTime.now().difference(statusStartAt);
    _streamDuration = StreamDuration(
      startCountAt,
      infinity: true,
      countUp: true,
      countUpAtDuration: true,
    );
    futurelocalStorage.then((value) {
      // value.remove(kLastStatus);
      final index = value.getInt(kLastStatus);
      value.setInt(kLastStatus, widget.order.status!.index);
      if (index != null) {
        lastStatus = OrderStatus.values[index];
        print('$lastStatus ${lastStatus.index}');
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _streamDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps =
        OrderStatus.values.where((e) => e.index >= OrderStatus.ordering.index);

    final l10n = context.l10n;

    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        var activeOrder = getActiveOrder(state.prevOrders);
        activeOrder ??= state.prevOrders.first;

        // final orderStatusTime = OrderStatus
        //     .values[lastStatus.index - 1]
        //     .toTime(widget.order);
        print(
            'New Active Status ${activeOrder.status} ${activeOrder.status!.index}');
        print('${lastStatus} ${lastStatus.index}');
        print(lastStatus.index < activeOrder.status!.index);
        if (lastStatus.index < activeOrder.status!.index) {
          if (activeOrder.status != OrderStatus.received) {
            // set last index for active order status
            futurelocalStorage.then((value) {
              value.setInt(kLastStatus, activeOrder!.status!.index);
            });
            // lastStatus = activeOrder.status!;

            resetTimerOnStatusChanged(
              context,
              activeOrder.id,
              activeOrder,
              _streamDuration.duration,
            );
          }
          // dont do anything if its received
          print('running from builder...');
        }
        return AppPageWidget(
          title: l10n.orderTrackerTitle,
          space: 15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    '${l10n.orderText} #${activeOrder.orderNumber}',
                  ),
                  subtitle: Text(
                    '${l10n.orderTimeText} ${DateFormat('h:mm:ss a').format(activeOrder.orderDate!)}',
                  ),
                ),
              ),
              Stepper(
                currentStep: currentStep == -1
                    ? activeOrder.status!.index - 3
                    : currentStep,
                controlsBuilder: (context, details) => Container(),
                onStepTapped: (value) {
                  setState(() {
                    currentStep = value;
                  });
                },
                stepIconBuilder: (stepIndex, stepState) {
                  return stepIconBuilderWidget(
                    stepState,
                    stepIndex,
                  );
                },
                steps: steps
                    .map(
                      (status) => statusStepWidget(status, activeOrder!, l10n),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void resetTimerOnStatusChanged(
    BuildContext context,
    String oid,
    Order activeOrder,
    Duration sDuration,
  ) {
    final duration = DateFormat.Hms().format(
      DateFormat.Hms().parse(sDuration.toString()),
    );
    // print(_streamDuration.duration);
    final prevStatus = OrderStatus.values[activeOrder.status!.index - 1];

    // final statusStartAt = getPrevouisStatusPeriod(activeOrder);
    // startCountAt = DateTime.now().difference(statusStartAt);
    // _streamDuration = StreamDuration(
    //   Duration.zero,
    //   infinity: true,
    //   countUp: true,
    //   countUpAtDuration: true,
    // );

    context.read<OrderBloc>().add(
          SaveStatusTimeEvent(
            oid: oid,
            duration: duration,
            prevStatus: prevStatus,
          ),
        );
  }

  Step statusStepWidget(
    OrderStatus status,
    Order activeOrder,
    AppLocalizations l10n,
  ) {
    final statusStartAt = getPrevouisStatusPeriod(activeOrder, status);

    return Step(
      title: Text(
        '${status.toName(l10n)}',
        style: TextStyle(
          color: status.index <= activeOrder.status!.index
              ? Colors.black
              : Colors.grey,
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.alarm_on_rounded),
          const SizedBox(width: 5),
          Text(
            '${l10n.startAtText} ${DateFormat('h:mm:ss a').format(statusStartAt)}',
          ),
          const Spacer(),
          if (activeOrder.status == status)
            Center(
              child: SlideCountdown(
                streamDuration: _streamDuration,
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
                separatorStyle:
                    TextStyle(color: Theme.of(context).primaryColor),
                shouldShowMinutes: (_) => true,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            )
          else
            Text(
              status.toTime(activeOrder) ?? l10n.noStatusTimerText,
            ),
        ],
      ),
      isActive: status.index <= activeOrder.status!.index,
      state: status.index <= activeOrder.status!.index
          ? StepState.complete
          : StepState.disabled,
    );
  }

  Widget stepIconBuilderWidget(StepState stepState, int stepIndex) {
    return stepState == StepState.complete
        ? const ColoredBox(
            color: Colors.white,
            child: Icon(
              Icons.check_circle,
              size: 28,
              color: Colors.green,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(4),
            child: Text(
              '${stepIndex + 1}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
  }
}
