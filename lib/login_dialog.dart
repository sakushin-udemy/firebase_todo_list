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
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      content: SizedBox(
        height: size.height * 0.8,
        width: size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _UserInfoInput(
                controller: _loginNameController,
                label: 'ログイン名',
              ),
              _UserInfoInput(
                controller: _emailController,
                label: 'E-mail',
              ),
              _UserInfoInput(
                controller: _nicknameController,
                label: 'ニックネーム',
              ),
              _UserInfoInput(
                controller: _passwordController,
                label: 'パスワード',
                obscureText: true,
              ),
              _UserInfoInput(
                controller: _confirmPasswordController,
                label: 'パスワードの確認',
                obscureText: true,
              ),
            ],
          ),
        ),
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
    this.obscureText,
  });

  final TextEditingController controller;
  final String label;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText ?? false,
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
      ),
    );
  }
}
