import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
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
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultDecoration = BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    );

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      decoration: defaultDecoration,
    );

    // Only the box currently focused gets the gold border — once a
    // digit is entered, focus (and the gold border) moves to the next
    // box automatically, and the filled box falls back to the default
    // theme below.
    final focusedPinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      decoration: defaultDecoration.copyWith(
        border: Border.all(color: AppColors.secondary, width: 2),
      ),
    );

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
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return AuthLayout(
          titleLine1: "Enter Verification",
          titleLine2: "Code",
          subtitle: "We've sent a 6-digit code to",
          child: Column(
            children: [
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 28),
              Pinput(
                controller: _otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: defaultPinTheme,
                showCursor: true,
                cursor: Container(
                  width: 2,
                  height: 22,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Wire this to whichever "resend" method
                      // AuthCubit exposes once it's ready.
                    },
                    child: const Text(
                      "Resend Code",
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              AppButton(
                text: "Verify",
                isLoading: state is AuthLoading,
                onPressed: () {
                  if (_otpController.text.length == 6) {
                    context.read<AuthCubit>().verifyOtp(
                      email: widget.email,
                      otp: _otpController.text,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}