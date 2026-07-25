import 'package:flutter/material.dart';

import 'app_button.dart';

class AppLoadingButton extends StatelessWidget {
  const AppLoadingButton({
    super.key,
    required this.loading,
    required this.text,
    required this.onPressed,
  });

  final bool loading;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AppButton(
      text: text,
      onPressed: onPressed,
    );
  }
}