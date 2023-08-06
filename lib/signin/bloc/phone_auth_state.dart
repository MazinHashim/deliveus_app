part of 'phone_auth_bloc.dart';

class PhoneAuthState extends Equatable {
  const PhoneAuthState({
    this.phone = const Phone.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.verificationId,
    this.duration = 60,
    this.timerStatus = TimerStatus.initial,
    this.isValid = false,
    this.otp = const OtpCode.pure(),
    this.errorMessage,
  });

  final Phone phone;
  final FormzSubmissionStatus status;
  final bool isValid;
  final TimerStatus timerStatus;
  final int duration;
  final OtpCode otp;
  final String? errorMessage;
  final String? verificationId;

  @override
  List<Object?> get props => [
        phone,
        status,
        duration,
        timerStatus,
        verificationId,
        otp,
        isValid,
        errorMessage
      ];

  PhoneAuthState copyWith({
    Phone? phone,
    FormzSubmissionStatus? status,
    bool? isValid,
    TimerStatus? timerStatus,
    OtpCode? otp,
    int? duration,
    String? verificationId,
    String? errorMessage,
  }) {
    return PhoneAuthState(
      phone: phone ?? this.phone,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      otp: otp ?? this.otp,
      verificationId: verificationId ?? this.verificationId,
      duration: duration ?? this.duration,
      timerStatus: timerStatus ?? this.timerStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum TimerStatus { initial, inProgress, complete }

extension TimerStatusX on TimerStatus {
  bool get isInitial => this == TimerStatus.initial;
  bool get isInProgress => this == TimerStatus.inProgress;
  bool get iscomplete => this == TimerStatus.complete;
}
