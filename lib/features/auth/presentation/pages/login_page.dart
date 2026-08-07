import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_layout.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;

  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, .12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.go('/home');
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return AuthLayout(
          titleLine1: "Welcome",
          titleLine2: "Back",
          subtitle: "Sign in to continue",
          showBackButton: false,
          showUnderline: false,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledField(
                      label: "Username",
                      field: AppTextField(
                        controller: usernameController,
                        hintText: "Enter your username",
                        prefixIcon: Icons.person_outline,
                        validator: Validators.requiredField,
                      ),
                    ),
                    const SizedBox(height: 20),
                    LabeledField(
                      label: "Password",
                      field: AppTextField(
                        controller: passwordController,
                        hintText: "Enter your password",
                        prefixIcon: Icons.lock_outline,
                        obscureText: isPasswordHidden,
                        validator: Validators.password,
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
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: const Text(
                          "Forgot Password?",
                          style: AppTextStyles.link,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppButton(
                      text: "Log In",
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        context.read<AuthCubit>().login(
                          username: usernameController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Your University. ",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: "Unified.",
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        "Academic Excellence & Community",
                        style: AppTextStyles.footer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}