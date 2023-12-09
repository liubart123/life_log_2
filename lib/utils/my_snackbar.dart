import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMyErrorSnackbar(String message) {
  Get.showSnackbar(
    GetSnackBar(
      message: 'Error: $message',
      backgroundColor: Get.theme.colorScheme.inverseSurface,
      borderRadius: 4,
      duration: const Duration(
        milliseconds: 5000,
      ),
      dismissDirection: DismissDirection.horizontal,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      shouldIconPulse: true,
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(
        milliseconds: 300,
      ),
    ),
  );
}
