import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void successDialog(String body, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Success'),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('OK'),
        )
      ],
    ),
  );
}

void errorDialog(String body, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('OK'),
        )
      ],
    ),
  );
}
