import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:delivery_repository/delivery_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template order_failure}
/// Thrown during the order manipulation if a failure occurs.
/// {@endtemplate}
class OrderFailure implements Exception {
  /// {@macro order_failure}
  const OrderFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an order failure message
  /// from a firebase firestore orders collection exception code.
  factory OrderFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const OrderFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const OrderFailure(
          'The credential received is malformed or has expired.',
        );
      default:
        return const OrderFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template order_repository}
/// Repository which manages order Data.
/// {@endtemplate}
class OrderRepository {
  /// {@macro orde_repository}
  OrderRepository({
    Future<SharedPreferences>? futurelocalStorage,
    firebase_firestore.FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? firebase_firestore.FirebaseFirestore.instance,
        _futurelocalStorage =
            futurelocalStorage ?? SharedPreferences.getInstance() {
    _init();
  }

  final firebase_firestore.FirebaseFirestore _firestore;
  final Future<SharedPreferences> _futurelocalStorage;
  late SharedPreferences _localStorage;

  final _itemsStreamController =
      BehaviorSubject<List<OrderItem>>.seeded(const []);

  /// Add Order data for specific user
  Future<void> saveOrder(Order order) async {
    try {
      await _firestore.collection('orders').doc().set(order.toJson());
    } on firebase_firestore.FirebaseException catch (e) {
      throw OrderFailure.fromCode(e.code);
    } catch (_) {
      throw const OrderFailure();
    }
  }

  /// Fetching Orders Data as order history for specific user
  Stream<List<Order>> getOrders(String userId) {
    try {
      final snapshot = _firestore
          .collection('orders')
          .where('user_id', isEqualTo: userId)
          .orderBy('order_date', descending: true)
          .snapshots();
      return snapshot.asBroadcastStream().map<List<Order>>(
            (data) => data.docs.map<Order>((e) {
              final dataWithId = e.data()..addAll({'id': e.id});
              return Order.fromJson(dataWithId);
            }).toList(),
          );
    } on firebase_firestore.FirebaseException catch (e) {
      throw OrderFailure.fromCode(e.code);
    } catch (_) {
      throw const OrderFailure();
    }
  }

  /// The key used for storing the todos locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kItemsCollectionKey = '__items_collection_key__';

  String? _getValue(String key) => _localStorage.getString(key);
  Future<bool> _setValue(String key, String value) =>
      _localStorage.setString(key, value);

  Future<void> _init() async {
    _localStorage = await _futurelocalStorage;
    final itemsJson = _getValue(kItemsCollectionKey);
    if (itemsJson != null) {
      final items = List<Map<dynamic, dynamic>>.from(
        json.decode(itemsJson) as List,
      )
          .map(
            (jsonMap) => OrderItem.fromJson(Map<String, dynamic>.from(jsonMap)),
          )
          .toList();
      _itemsStreamController.add(items);
    } else {
      _itemsStreamController.add(const <OrderItem>[]);
    }
  }

  /// fetch locally stored orderItems
  Stream<List<OrderItem>> getOrderItems() =>
      _itemsStreamController.asBroadcastStream();

  /// save order Item
  Future<bool> saveOrderItem(OrderItem item) {
    final items = [..._itemsStreamController.value];
    final itemIndex = items.indexWhere((t) => t.foodId == item.foodId);
    if (itemIndex >= 0) {
      items[itemIndex] = item;
    } else {
      items.add(item);
    }

    _itemsStreamController.add(items);
    return _setValue(kItemsCollectionKey, json.encode(items));
  }

  /// remove order Item
  Future<bool> removeOrderItem(String id) {
    final items = [..._itemsStreamController.value];
    final itemIndex = items.indexWhere((t) => t.foodId == id);
    if (itemIndex == -1) {
      throw const OrderFailure();
    } else {
      items.removeAt(itemIndex);
      _itemsStreamController.add(items);
      return _setValue(kItemsCollectionKey, json.encode(items));
    }
  }

  /// clear order Items
  Future<bool> clearOrderItems() {
    final items = [..._itemsStreamController.value]..clear();
    _itemsStreamController.add(items);
    return _setValue(kItemsCollectionKey, json.encode(items));
  }
}
