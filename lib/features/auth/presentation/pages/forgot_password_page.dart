import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../controllers/forgetpassword_form_controller.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {

  final controller = ForgotPasswordFormController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return  BlocConsumer<AuthCubit, AuthState>(

        listener: (context, state) {

          if(state is ForgotPasswordSuccess){

            context.push(
              "/verify-otp",
              extra: controller.emailController.text.trim(),
            );

          }

          if(state is AuthFailure){

            ScaffoldMessenger.of(context)
                .showSnackBar(

              SnackBar(
                content: Text(state.message),
              ),

            );

          }

        },

        builder: (context, state) {
          return SafeArea(

            child: Padding(

              padding: const EdgeInsets.all(24),

              child: Form(

                key: controller.formKey,

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const SizedBox(height: 20),

                    Text(

                      "Forgot Password",

                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium,

                    ),

                    const SizedBox(height: 12),

                    Text(

                      "Enter your email address to receive a verification code.",

                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,

                    ),

                    const SizedBox(height: 32),

                    AppTextField(

                      controller: controller.emailController,

                      hintText: "Email",

                      keyboardType:
                      TextInputType.emailAddress,

                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Email is required";
                        }

                        return null;
                      },

                    ),

                    const SizedBox(height: 30),

                    state is AuthLoading

                        ? const Center(
                        child:
                        CircularProgressIndicator())

                        : SizedBox(

                      width: double.infinity,

                      child: AppButton(

                        text: "Send OTP",

                        onPressed: () {
                          if (controller.formKey.currentState!
                              .validate()) {
                            context
                                .read<AuthCubit>()
                                .forgotPassword(

                              email: controller.emailController
                                  .text
                                  .trim(),

                            );
                          }
                        },

                      ),

                    ),

                    const SizedBox(height: 20),

                    Center(

                      child: TextButton(

                        onPressed: () {
                          context.pop();
                        },

                        child: const Text(
                          "Back to Login",
                        ),

                      ),

                    )

                  ],

                ),

              ),

            ),


          );


        });

  }

}