import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/signin/bloc/phone_auth_bloc.dart';
import 'package:deleveus_app/signin/widgets/widgets.dart';
import 'package:deleveus_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class OtpForm extends StatelessWidget {
  const OtpForm({required this.state, super.key});

  final PhoneAuthState state;
  @override
  Widget build(BuildContext context) {
    final duration = state.duration;
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');

    final l10n = context.l10n;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTitle(
          title: l10n.otpVerifyTitle,
          icon: Icons.verified_user,
          isAuth: true,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset('assets/imgs/otp.png'),
        ),
        Text(l10n.notifySendVerificationText),
        Text(l10n.otpYourPhoneText),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColorLight,
              ),
              Text(state.phone.value, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: OtpInput(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: state.timerStatus.isInProgress
                    ? null
                    : () {
                        context.read<PhoneAuthBloc>().add(
                              SendOtpToPhoneEvent(
                                phoneNumber: state.phone.value,
                                isResend: true,
                              ),
                            );
                        context.read<PhoneAuthBloc>().add(const TimerReset());
                      },
                child: Text(
                  l10n.otpResendQuesText,
                  style: TextStyle(
                    color: state.timerStatus.isInitial ||
                            state.timerStatus.isInProgress
                        ? Colors.grey
                        : Theme.of(context).primaryColorLight,
                  ),
                ),
              ),
              Text('$minutesStr:$secondsStr'),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: state.status.isInProgress
              ? const Center(
                  child: CircularProgressIndicator(strokeWidth: 1),
                )
              : ElevatedButton.icon(
                  onPressed: () {
                    context.read<PhoneAuthBloc>().add(
                          VerifySentOtpEvent(
                            otpCode: state.otp.value,
                            verificationId: state.verificationId!,
                          ),
                        );
                  },
                  icon: const Icon(Icons.login),
                  label: Text(l10n.otpSigninButtonText),
                ),
        ),
      ],
    );
  }
}
