import 'package:flutter/material.dart';

class OtpFormController {
  final otpController = TextEditingController();

  void dispose() {
    otpController.dispose();
  }
}