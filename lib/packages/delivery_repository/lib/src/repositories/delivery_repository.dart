import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:delivery_repository/delivery_repository.dart';

/// {@template delivery_failure}
/// Thrown during the delivery manipulation if a failure occurs.
/// {@endtemplate}
class DeliveryFailure implements Exception {
  /// {@macro delivery_failure}
  const DeliveryFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an delivery failure message
  factory DeliveryFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const DeliveryFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const DeliveryFailure(
          'The credential received is malformed or has expired.',
        );
      default:
        return const DeliveryFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template delivery_repository}
/// Repository which manages delivery Data.
/// {@endtemplate}
class DeliveryRepository {
  /// {@macro orde_repository}
  DeliveryRepository({
    // Future<SharedPreferences>? futurelocalStorage,
    firebase_firestore.FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? firebase_firestore.FirebaseFirestore.instance;
  // _futurelocalStorage =
  //     futurelocalStorage ?? SharedPreferences.getInstance()

  final firebase_firestore.FirebaseFirestore _firestore;
  // final Future<SharedPreferences> _futurelocalStorage;
  // late SharedPreferences _localStorage;

  /// fetch current location of the device
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled().timeout(
      const Duration(seconds: 6),
      onTimeout: () {
        return Future.error('Location services are disabled.');
      },
    );
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Permissions are permanently denied, we cannot request permissions.',
      );
    }
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Fetching Branches
  Stream<List<Branch>> getBranches() {
    try {
      final snapshot = _firestore.collection('branches').snapshots();
      return snapshot.asBroadcastStream().map<List<Branch>>((data) {
        return data.docs.map<Branch>((e) {
          final dataWithId = e.data()..addAll({'id': e.id});
          return Branch.fromJson(dataWithId);
        }).toList();
      });
    } on firebase_firestore.FirebaseException catch (e) {
      throw DeliveryFailure.fromCode(e.code);
    } catch (_) {
      throw const DeliveryFailure();
    }
  }
}
