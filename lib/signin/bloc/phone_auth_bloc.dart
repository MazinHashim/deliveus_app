import 'dart:async';

import 'package:deleveus_app/signin/bloc/ticker.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  PhoneAuthBloc(this._authenticationRepository, {required Ticker ticker})
      : _ticker = ticker,
        super(const PhoneAuthState()) {
    // When user clicks on send otp button then this event will be fired
    on<SendOtpToPhoneEvent>(_onSendOtp);

    // After receiving the otp, When user clicks on verify otp button then this
    // event will be fired
    on<VerifySentOtpEvent>(_onVerifyOtp);

    // When the firebase sends the code to the user's phone, this event will be
    // fired
    on<OnPhoneOtpSent>((event, emit) {
      emit(
        state.copyWith(
          isValid: false, // clear form validation
          status: FormzSubmissionStatus.success,
          verificationId: event.verificationId,
        ),
      );
    });

    // When any error occurs while sending otp to the user's phone, this event
    // will be fired
    on<OnPhoneAuthErrorEvent>(
      (event, emit) => emit(
        state.copyWith(
          errorMessage: event.error,
          status: FormzSubmissionStatus.failure,
        ),
      ),
    );
    on<PhoneChangedEvent>(phoneChanged);
    on<OtpCodeChangedEvent>(otpCodeChanged);

    // When the otp verification is successful, this event will be fired
    on<OnPhoneAuthVerificationCompleteEvent>(_loginWithCredential);

    on<TimerStarted>(_onStarted);
    on<_TimerTicked>(_onTicked);
    on<TimerReset>(_onReset);
  }
  StreamSubscription<int>? _tickerSubscription;
  final AuthenticationRepository _authenticationRepository;
  final Ticker _ticker;

  void phoneChanged(
    PhoneChangedEvent event,
    Emitter<PhoneAuthState> emit,
  ) {
    final phone = Phone.dirty(event.value);
    emit(state.copyWith(phone: phone, isValid: Formz.validate([phone])));
  }

  void otpCodeChanged(
    OtpCodeChangedEvent event,
    Emitter<PhoneAuthState> emit,
  ) {
    final otpCode = OtpCode.dirty(event.value);
    emit(state.copyWith(otp: otpCode, isValid: Formz.validate([otpCode])));
  }

  FutureOr<void> _onSendOtp(
    SendOtpToPhoneEvent event,
    Emitter<PhoneAuthState> emit,
  ) async {
    if (!event.isResend) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      );
      if (!state.isValid) return;
    }
    try {
      await _authenticationRepository.verifyPhone(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // On [verificationComplete], we will get the credential from the
          //firebase  and will send it to the
          //[OnPhoneAuthVerificationCompleteEvent] event to be handled by the
          //bloc and then will emit the [PhoneAuthVerified] state after
          //successful login
          add(OnPhoneAuthVerificationCompleteEvent(credential: credential));
        },
        codeSent: (String verificationId, int? resendToken) {
          // On [codeSent], we will get the verificationId and the resendToken
          //from the firebase and will send it to the [OnPhoneOtpSent] event to
          //be handled by the bloc and then will emit the
          //[OnPhoneAuthVerificationCompleteEvent] event after receiving the
          //code from the user's phone
          add(
            OnPhoneOtpSent(verificationId: verificationId, token: resendToken),
          );
          add(const TimerStarted(duration: 60));
        },
        verificationFailed: (FirebaseAuthException e) {
          // On [verificationFailed], we will get the exception from the
          //firebase and will send it to the [OnPhoneAuthErrorEvent] event to be
          // handled by the bloc and then will emit the [PhoneAuthError] state
          //in order to display the error to the user's screen
          add(
            OnPhoneAuthErrorEvent(
              error: VerifyPhoneNumberFailure.fromCode(e.code).message,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on VerifyPhoneNumberFailure catch (e, _) {
      add(OnPhoneAuthErrorEvent(error: e.message));
    }
  }

  FutureOr<void> _onVerifyOtp(
    VerifySentOtpEvent event,
    Emitter<PhoneAuthState> emit,
  ) async {
    if (!state.isValid) return;
    try {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      // After receiving the otp, we will verify the otp and then will create a
      //credential from the otp and verificationId and then will send it to the
      //[OnPhoneAuthVerificationCompleteEvent] event to be handled by the bloc
      //and then will emit the [PhoneAuthVerified] state after successful login

      final credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otpCode,
      );
      add(OnPhoneAuthVerificationCompleteEvent(credential: credential));
    } on VerifyPhoneNumberFailure catch (e) {
      add(OnPhoneAuthErrorEvent(error: e.message));
    }
  }

  FutureOr<void> _loginWithCredential(
    OnPhoneAuthVerificationCompleteEvent event,
    Emitter<PhoneAuthState> emit,
  ) async {
    //After receiving the credential from the event, we will login with the
    //credential and then will emit the [PhoneAuthVerified] state after
    //successful login
    try {
      await _authenticationRepository
          .signInWithCredntial(event.credential)
          .then((user) {
        final appuser = _authenticationRepository.currentUser;
        if (appuser.isNotEmpty) {
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        }
      });
    } on VerifyPhoneNumberFailure catch (e) {
      add(OnPhoneAuthErrorEvent(error: e.message));
    } catch (e) {
      add(OnPhoneAuthErrorEvent(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<PhoneAuthState> emit) {
    emit(
      state.copyWith(
        timerStatus: TimerStatus.initial,
        duration: event.duration,
      ),
    );
    _tickerSubscription?.cancel();
    _tickerSubscription =
        _ticker.tick(ticks: event.duration).listen((duration) {
      add(_TimerTicked(duration: duration));
    });
  }

  void _onTicked(_TimerTicked event, Emitter<PhoneAuthState> emit) {
    emit(
      state.copyWith(
        timerStatus:
            event.duration > 0 ? TimerStatus.inProgress : TimerStatus.complete,
        duration: event.duration,
      ),
    );
  }

  void _onReset(TimerReset event, Emitter<PhoneAuthState> emit) {
    _tickerSubscription?.cancel();
    emit(state.copyWith(timerStatus: TimerStatus.initial, duration: 60));
  }
}
