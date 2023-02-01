import 'package:flutter/material.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('完了'),
        )
      ],
    );
  }
}
