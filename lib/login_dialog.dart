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
          _UserInfoInput(
            controller: _loginNameController,
            label: 'ログイン名',
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

class _UserInfoInput extends StatelessWidget {
  const _UserInfoInput({
    super.key,
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            width: 2,
          ),
        ),
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            width: 1,
          ),
        ),
      ),
    );
  }
}
