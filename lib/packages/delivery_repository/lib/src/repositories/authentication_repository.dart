import 'package:cache/cache.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';

/// {@template sign_up_with_phone_number_failure}
/// Thrown during the sign up process if a failure occurs.
/// {@endtemplate}
class VerifyPhoneNumberFailure implements Exception {
  /// {@macro sign_up_with_phone_number_failure}
  const VerifyPhoneNumberFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithPhoneNumber.html
  factory VerifyPhoneNumberFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const VerifyPhoneNumberFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const VerifyPhoneNumberFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const VerifyPhoneNumberFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const VerifyPhoneNumberFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const VerifyPhoneNumberFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const VerifyPhoneNumberFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const VerifyPhoneNumberFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const VerifyPhoneNumberFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const VerifyPhoneNumberFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    // firebase_firestore.FirebaseFirestore? firestore,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
  // _firestore = firestore ?? firebase_firestore.FirebaseFirestore.instance;

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  // final firebase_firestore.FirebaseFirestore _firestore;

  /// Whether or not the current environment is web
  /// Should only be overridden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User get currentUser {
    // _cache.clear();
    final user = _cache.read<User>(key: userCacheKey);
    return user ?? User.empty;
  }

  /// Verify a new user with the provided [user.first.phone]
  ///
  /// Throws a [VerifyPhoneNumberFailure] if an exception occurs.
  Future<void> verifyPhone({
    required String phoneNumber,
    required void Function(firebase_auth.PhoneAuthCredential)
        verificationCompleted,
    required void Function(firebase_auth.FirebaseAuthException)
        verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw VerifyPhoneNumberFailure.fromCode(e.code);
    } catch (_) {
      throw const VerifyPhoneNumberFailure();
    }
  }

  /// Sign In a new user with the provided [user.first.phone]
  ///
  /// Throws a [VerifyPhoneNumberFailure] if an exception occurs.
  Future<firebase_auth.UserCredential> signInWithCredntial(
    firebase_auth.PhoneAuthCredential credential,
  ) async {
    try {
      final user = await _firebaseAuth.signInWithCredential(credential);
      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw VerifyPhoneNumberFailure.fromCode(e.code);
    } catch (_) {
      throw const VerifyPhoneNumberFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  /// Maps a [firebase_auth.User] into a [User].
  User get toUser {
    return User(
      id: uid,
      phone: phoneNumber,
      email: '',
      firstname: '',
      lastname: '',
    );
  }
}
