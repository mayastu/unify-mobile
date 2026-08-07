import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_layout.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../controllers/forgetpassword_form_controller.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final controller = ForgotPasswordFormController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          context.push(
            "/verify-otp",
            extra: controller.emailController.text.trim(),
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
          titleLine1: "Forgot",
          titleLine2: "Password",
          subtitle:
          "Enter your university email and we'll send you a verification code.",
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledField(
                  label: "Email",
                  field: AppTextField(
                    controller: controller.emailController,
                    hintText: "Enter your email",
                    prefixIcon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                AppButton(
                  text: "Send Code",
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      context.read<AuthCubit>().forgotPassword(
                        email: controller.emailController.text.trim(),
                      );
                    }
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