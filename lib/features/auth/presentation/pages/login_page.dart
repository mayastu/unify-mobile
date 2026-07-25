import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(

      listener: (context, state) {

        if(state is LoginSuccess){

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Success"),
            ),
          );

        }

        if(state is AuthFailure){

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );

        }

      },
      builder: (context, state) {

        return Scaffold(

          body: SafeArea(

            child: Padding(

              padding: const EdgeInsets.all(24),

              child: Form(

                key: formKey,

                child: Column(

                  children: [
                    AppTextField(

                      controller: usernameController,

                      hintText: "Username",

                      prefixIcon: Icons.person,

                      validator: Validators.requiredField,

                    ),
                    const SizedBox(height:20),

                    AppTextField(

                      controller: passwordController,

                      hintText: "Password",

                      prefixIcon: Icons.lock,

                      obscureText: true,

                      validator: Validators.password,

                    ),
                    const SizedBox(height:30),

                    AppButton(

                      text: "Login",

                      isLoading: state is AuthLoading,

                      onPressed: (){

                        if(!formKey.currentState!.validate()){

                          return;

                        }

                        context.read<AuthCubit>().login(

                          username: usernameController.text.trim(),

                          password: passwordController.text.trim(),

                        );

                      },

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
