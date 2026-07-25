import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_layout.dart';
import '../controllers/resetpassword_form_controller.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  State<ResetPasswordPage> createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState
    extends State<ResetPasswordPage> {

  final controller =
  ResetPasswordFormController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthCubit, AuthState>(

      listener: (context, state) {

        if (state is ResetPasswordSuccess) {

          AppSnackBar.success(
            context,
            "Password changed successfully",
          );

          context.go("/login");

        }

        if (state is AuthFailure) {

          AppSnackBar.error(
            context,
            state.message,
          );

        }

      },

      builder: (context, state) {

        return AuthLayout(

          title: "Create New Password",

          subtitle:
          "Enter your new password.",

          child: Form(

            key: controller.formKey,

            child: Column(

              children: [

                AppTextField(
                  controller:
                  controller.passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                AppTextField(
                  controller: controller
                      .confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),

                const SizedBox(height: 30),

                SizedBox(

                  width: double.infinity,

                  child: AppLoadingButton(

                    loading:
                    state is AuthLoading,

                    text: "Reset Password",

                    onPressed: () {

                      if (controller.passwordController.text !=
                          controller
                              .confirmPasswordController
                              .text) {

                        AppSnackBar.error(
                          context,
                          "Passwords do not match",
                        );

                        return;

                      }

                      context
                          .read<AuthCubit>()
                          .resetPassword(

                        email: widget.email,

                        otp: widget.otp,

                        password: controller
                            .passwordController
                            .text,

                        confirmPassword:
                        controller
                            .confirmPasswordController
                            .text,

                      );

                    },

                  ),

                )

              ],

            ),

          ),

        );

      },

    );

  }

}