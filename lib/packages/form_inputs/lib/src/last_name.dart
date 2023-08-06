import 'package:formz/formz.dart';

/// Validation errors for the [lastName] [FormzInput].
enum LastNameValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template lastName}
/// Form input for an lastName input.
/// {@endtemplate}
class LastName extends FormzInput<String, LastNameValidationError> {
  /// {@macro lastName}
  const LastName.pure() : super.pure('');

  /// {@macro lastName}
  const LastName.dirty([super.value = '']) : super.dirty();

  // static final RegExp _lastNameRegExp = RegExp(
  //   r'^[0-9]{6}$',
  // );

  @override
  LastNameValidationError? validator(String? value) {
    // return _lastNameRegExp.hasMatch(value ?? '')
    //     ? null
    //     : LastNameValidationError.invalid;
    return value!.isNotEmpty ? null : LastNameValidationError.invalid;
  }
}
