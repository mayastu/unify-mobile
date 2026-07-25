import 'package:flutter/material.dart';

class ResetPasswordFormController {
  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}