import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:delivery_repository/delivery_repository.dart';

/// {@template food_failure}
/// Thrown during the user manipulation if a failure occurs.
/// {@endtemplate}
class FoodFailure implements Exception {
  /// {@macro food_failure}
  const FoodFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create a user failure message
  /// from a firebase firestore users collection exception code.
  factory FoodFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const FoodFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const FoodFailure(
          'The credential received is malformed or has expired.',
        );
      default:
        return const FoodFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template food_repository}
/// Repository which manages user Data.
/// {@endtemplate}
class FoodRepository {
  /// {@macro food_repository}
  FoodRepository({
    firebase_firestore.FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? firebase_firestore.FirebaseFirestore.instance;

  final firebase_firestore.FirebaseFirestore _firestore;

  /// Fetching Foods or filtered foods
  Stream<List<Food>> getFoods([String? category]) {
    try {
      final snapshot = category == null
          ? _firestore.collection('foods').snapshots()
          : _firestore
              .collection('foods')
              .where('category', isEqualTo: category)
              .snapshots();
      return snapshot.asBroadcastStream().map<List<Food>>((data) {
        return data.docs.map<Food>((e) {
          final dataWithId = e.data()..addAll({'id': e.id});
          return Food.fromJson(dataWithId);
        }).toList();
      });
    } on firebase_firestore.FirebaseException catch (e) {
      throw FoodFailure.fromCode(e.code);
    } catch (_) {
      throw const FoodFailure();
    }
  }

  /// Fetching Foods or filtered foods
  Stream<Set<String>> getFoodCategories() {
    try {
      final snapshot = _firestore.collection('foods').snapshots();
      return snapshot.asBroadcastStream().map<Set<String>>((data) {
        return data.docs.map<String>((e) {
          return e.data()['category'].toString();
        }).toSet();
      });
    } on firebase_firestore.FirebaseException catch (e) {
      throw FoodFailure.fromCode(e.code);
    } catch (_) {
      throw const FoodFailure();
    }
  }
}
