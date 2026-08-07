import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_layout.dart';
import '../../../../core/widgets/labeled_field.dart';
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
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final controller = ResetPasswordFormController();

  bool isPasswordHidden = true;
  bool isConfirmHidden = true;

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
          AppSnackBar.success(context, "Password changed successfully");
          context.go("/login");
        }

        if (state is AuthFailure) {
          AppSnackBar.error(context, state.message);
        }
      },
      builder: (context, state) {
        return AuthLayout(
          titleLine1: "Reset",
          titleLine2: "Password",
          subtitle: "Enter your new password below.",
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledField(
                  label: "New Password",
                  field: AppTextField(
                    controller: controller.passwordController,
                    hintText: "Enter new password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: isPasswordHidden,
                    suffixIcon: IconButton(
                      splashRadius: 22,
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                LabeledField(
                  label: "Confirm Password",
                  field: AppTextField(
                    controller: controller.confirmPasswordController,
                    hintText: "Confirm new password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: isConfirmHidden,
                    suffixIcon: IconButton(
                      splashRadius: 22,
                      icon: Icon(
                        isConfirmHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmHidden = !isConfirmHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                AppButton(
                  text: "Update Password",
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    if (controller.passwordController.text !=
                        controller.confirmPasswordController.text) {
                      AppSnackBar.error(context, "Passwords do not match");
                      return;
                    }

                    context.read<AuthCubit>().resetPassword(
                      email: widget.email,
                      otp: widget.otp,
                      password: controller.passwordController.text,
                      confirmPassword:
                      controller.confirmPasswordController.text,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}