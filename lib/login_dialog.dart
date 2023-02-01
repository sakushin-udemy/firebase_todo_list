import 'package:flutter/material.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _loginNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  width: 2,
                ),
              ),
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              labelText: 'ログイン名',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('完了'),
        )
      ],
    );
  }

  @override
  void dispose() {
    _loginNameController.dispose();
    _emailController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
