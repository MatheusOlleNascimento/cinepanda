import 'package:flutter/material.dart';

import '../imports/styles.dart';

void snackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: CustomTheme.red)),
      backgroundColor: CustomTheme.grey,
      duration: const Duration(seconds: 3),
    ),
  );
}
