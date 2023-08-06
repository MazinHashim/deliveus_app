import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:delivery_repository/delivery_repository.dart';

/// {@template user_failure}
/// Thrown during the user manipulation if a failure occurs.
/// {@endtemplate}
class UserFailure implements Exception {
  /// {@macro user_failure}
  const UserFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create a user failure message
  /// from a firebase firestore users collection exception code.
  factory UserFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const UserFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const UserFailure(
          'The credential received is malformed or has expired.',
        );
      default:
        return const UserFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template user_repository}
/// Repository which manages user Data.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    firebase_firestore.FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? firebase_firestore.FirebaseFirestore.instance;

  final firebase_firestore.FirebaseFirestore _firestore;

  /// save [user] to the users collection in the firestore database.
  Future<User> saveUserData(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      return user;
    } on firebase_firestore.FirebaseException catch (e) {
      throw UserFailure.fromCode(e.code);
    } catch (_) {
      throw const UserFailure();
    }
  }

  /// fetch [fuser] data if exsisting in firestore database
  Future<User> getUserData(User fuser, {bool toSignIn = false}) async {
    if (fuser.isEmpty) return fuser;
    try {
      final userSnapShot =
          await _firestore.collection('users').doc(fuser.id).get();
      if (userSnapShot.exists && userSnapShot.data()!.containsKey('id')) {
        return User.fromJson(userSnapShot.data()!);
      } else if (toSignIn) {
        final user = await saveUserData(fuser);
        return user;
      } else {
        return fuser;
      }
    } on firebase_firestore.FirebaseException catch (e) {
      throw UserFailure.fromCode(e.code);
    } catch (e) {
      throw const UserFailure();
    }
  }
}
