import 'package:flutter/material.dart';

class ForgotPasswordFormController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  void dispose() {
    emailController.dispose();
  }
}