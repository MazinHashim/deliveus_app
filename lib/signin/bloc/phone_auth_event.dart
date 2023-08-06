part of 'phone_auth_bloc.dart';

sealed class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object> get props => [];
}

class SendOtpToPhoneEvent extends PhoneAuthEvent {
  const SendOtpToPhoneEvent({required this.phoneNumber, this.isResend = false});

  final String phoneNumber;
  final bool isResend;

  @override
  List<Object> get props => [phoneNumber];
}

class PhoneChangedEvent extends PhoneAuthEvent {
  const PhoneChangedEvent({required this.value});

  final String value;

  @override
  List<Object> get props => [value];
}

class OtpCodeChangedEvent extends PhoneAuthEvent {
  const OtpCodeChangedEvent({required this.value});

  final String value;

  @override
  List<Object> get props => [value];
}

class VerifySentOtpEvent extends PhoneAuthEvent {
  const VerifySentOtpEvent({
    required this.otpCode,
    required this.verificationId,
  });
  final String otpCode;
  final String verificationId;

  @override
  List<Object> get props => [otpCode, verificationId];
}

class OnPhoneOtpSent extends PhoneAuthEvent {
  const OnPhoneOtpSent({
    required this.verificationId,
    required this.token,
  });
  final String verificationId;
  final int? token;

  @override
  List<Object> get props => [verificationId];
}

class OnPhoneAuthErrorEvent extends PhoneAuthEvent {
  const OnPhoneAuthErrorEvent({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}

class OnPhoneAuthVerificationCompleteEvent extends PhoneAuthEvent {
  const OnPhoneAuthVerificationCompleteEvent({
    required this.credential,
  });
  final PhoneAuthCredential credential;
}

final class TimerStarted extends PhoneAuthEvent {
  const TimerStarted({required this.duration});
  final int duration;
}

class TimerReset extends PhoneAuthEvent {
  const TimerReset();
}

class _TimerTicked extends PhoneAuthEvent {
  const _TimerTicked({required this.duration});
  final int duration;
}
