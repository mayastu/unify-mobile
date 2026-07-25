import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/auth_layout.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState
    extends State<OtpVerificationPage> {

  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthCubit, AuthState>(

      listener: (context, state) {

        if (state is VerifyOtpSuccess) {

          context.push(

            "/reset-password",

            extra: {

              "email": widget.email,

              "otp": _otpController.text,

            },

          );

        }

        if (state is AuthFailure) {

          ScaffoldMessenger.of(context).showSnackBar(

            SnackBar(

              content: Text(state.message),

            ),

          );

        }

      },

      builder: (context, state) {

        return AuthLayout(

          title: "OTP Verification",

          subtitle:
          "Enter the verification code sent to\n${widget.email}",

          child: Column(

            children: [

              Pinput(

                controller: _otpController,

                length: 6,

              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                child: AppLoadingButton(

                  loading: state is AuthLoading,

                  text: "Verify",

                  onPressed: () {

                    if (_otpController.text.length == 6) {

                      context
                          .read<AuthCubit>()
                          .verifyOtp(

                        email: widget.email,

                        otp: _otpController.text,

                      );

                    }

                  },

                ),

              ),

            ],

          ),

        );

      },

    );

  }

}