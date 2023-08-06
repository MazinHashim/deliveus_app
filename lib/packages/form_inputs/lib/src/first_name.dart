import 'package:formz/formz.dart';

/// Validation errors for the [FirstName] [FormzInput].
enum FirstNameValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template firstName}
/// Form input for an firstName input.
/// {@endtemplate}
class FirstName extends FormzInput<String, FirstNameValidationError> {
  /// {@macro firstName}
  const FirstName.pure() : super.pure('');

  /// {@macro firstName}
  const FirstName.dirty([super.value = '']) : super.dirty();

  // static final RegExp _firstNameRegExp = RegExp(
  //   r'^[0-9]{6}$',
  // );

  @override
  FirstNameValidationError? validator(String? value) {
    // return _firstNameRegExp.hasMatch(value ?? '')
    //     ? null
    //     : FirstNameValidationError.invalid;
    return value!.isNotEmpty ? null : FirstNameValidationError.invalid;
  }
}
