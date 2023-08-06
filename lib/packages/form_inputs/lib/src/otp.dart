import 'package:formz/formz.dart';

/// Validation errors for the [OtpCode] [FormzInput].
enum OtpValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template otpCode}
/// Form input for an otpCode input.
/// {@endtemplate}
class OtpCode extends FormzInput<String, OtpValidationError> {
  /// {@macro otpCode}
  const OtpCode.pure() : super.pure('');

  /// {@macro otpCode}
  const OtpCode.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[0-9]{6}$',
  );

  @override
  OtpValidationError? validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '')
        ? null
        : OtpValidationError.invalid;
  }
}
