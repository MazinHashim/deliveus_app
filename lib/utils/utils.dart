import 'package:deleveus_app/l10n/l10n.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';

const kLastStatus = '__last_status_key__';

Order? getActiveOrder(List<Order> prevOrders) {
  final currentActiveOrder = prevOrders.where(
    (order) =>
        order.status != OrderStatus.received &&
        order.status != OrderStatus.failure,
  );
  if (currentActiveOrder.isNotEmpty) {
    return currentActiveOrder.first;
  }
  return null;
}

DateTime getPrevouisStatusPeriod(Order order, [OrderStatus? status]) {
  var moment = order.orderDate!;
  // print(status!.index);
  if (status != null && status.index > OrderStatus.delivering.index) {
    return moment;
  }
  for (var i = (status != null ? status.index : order.status!.index);
      i > OrderStatus.ordering.index;
      i--) {
    final tr = OrderStatus.values[i - 1].toTime(order);
    if (tr == null) {
      return moment;
    }
    final time = DateFormat.Hms().parse(tr);
    moment = moment.add(
      Duration(hours: time.hour, minutes: time.minute, seconds: time.second),
    );
  }
  return moment;
}

Text selectNewOrderDestination(Order order, AppLocalizations l10n) {
  if (order.fromBranch == null &&
      (order.destinationLat == null && order.destinationLong == null)) {
    return Text(l10n.noDestinationSelectedText);
  } else {
    if (order.fromBranch == null) {
      return Text(
        '${l10n.thisOrderText} ${l10n.deliverToDestinationText} ${order.address}',
      );
    } else {
      return Text(
        '${l10n.thisOrderText} ${l10n.pickupFromBranchText} ${order.fromBranch}',
      );
    }
  }
}

extension OrderStatusColor on OrderStatus {
  Color toColor() {
    return switch (this) {
      OrderStatus.ordering => Colors.green,
      OrderStatus.cooking => Colors.amber,
      OrderStatus.delivering => Colors.blue,
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

extension OrderStatusTime on OrderStatus {
  String? toTime(Order order) {
    return switch (this) {
      OrderStatus.ordering => order.orderingTime,
      OrderStatus.cooking => order.cookingTime,
      OrderStatus.delivering => order.deliveringTime,
      _ => 'No Timer',
    };
  }
}

extension OrderStatusName on OrderStatus {
  String toName(AppLocalizations l10n) {
    return switch (this) {
      OrderStatus.ordering => l10n.orderingStatusTitle,
      OrderStatus.cooking => l10n.cookingStatusTitle,
      OrderStatus.delivering => l10n.deliveringStatusTitle,
      OrderStatus.received => l10n.receivedStatusTitle,
      _ => 'No Timer',
    };
  }
}
