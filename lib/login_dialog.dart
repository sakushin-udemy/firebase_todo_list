import 'package:firebase_todo_list/repositories/authentication_repository.dart';
import 'package:firebase_todo_list/repositories/user_repository.dart';
import 'package:flutter/material.dart';

import 'data/db_user.dart';

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

  bool _isRegister = false;
  final _formKey = GlobalKey<FormState>();

  final auth = AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      content: SizedBox(
        height: size.height * 0.8,
        width: size.width * 0.8,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('新規登録'),
                    Checkbox(
                      value: _isRegister,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _isRegister = value;
                        });
                      },
                    ),
                    StreamBuilder<bool>(
                        stream: auth.isLogin(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          return Text(snapshot.data! ? 'ログイン中' : 'ログアウト中');
                        })
                  ],
                ),
                _UserInfoInput(
                  controller: _loginNameController,
                  label: 'ログイン名',
                ),
                if (_isRegister)
                  _UserInfoInput(
                    controller: _emailController,
                    label: 'E-mail',
                  ),
                if (_isRegister)
                  _UserInfoInput(
                    controller: _nicknameController,
                    label: 'ニックネーム',
                  ),
                _UserInfoInput(
                  controller: _passwordController,
                  label: 'パスワード',
                  obscureText: true,
                ),
                if (_isRegister)
                  _UserInfoInput(
                    controller: _confirmPasswordController,
                    label: 'パスワードの確認',
                    obscureText: true,
                    equalsController: _passwordController,
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => auth.signOut(),
          child: const Text('ログアウト'),
        ),
        TextButton(
          onPressed: () async {
            final result = _formKey.currentState?.validate() ?? false;
            if (!result) {
              return;
            }

            _formKey.currentState!.save();

            final user = DbUser(
              authenticationId: '',
              loginName: _loginNameController.text,
              email: _emailController.text,
              nickname: _nicknameController.text,
            );

            final repository = AuthenticationRepository();
            if (_isRegister) {
              final uid =
                  await repository.register(user, _passwordController.text);
              final userWithUid = user.copyWith(authenticationId: uid);

              final userRepository = UserRepository();
              await userRepository.add(userWithUid);
            } else {
              final userRepository = UserRepository();
              final user = await userRepository
                  .findByLoginName(_loginNameController.text);
              auth.login(user.email, _passwordController.text);
            }
          },
          child: Text(_isRegister ? '登録' : 'ログイン'),
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
  _UserInfoInput({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText,
    this.equalsController,
  });

  final TextEditingController controller;
  final String label;
  final bool? obscureText;
  final TextEditingController? equalsController;

  final boaderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(
      width: 1,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText ?? false,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return '必須です';
          }

          if (equalsController != null) {
            if (controller.text != equalsController!.text) {
              return 'パスワードが一致しません';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          border: boaderStyle,
          focusedBorder: boaderStyle.copyWith(
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          labelText: label,
          enabledBorder: boaderStyle,
          errorBorder: boaderStyle.copyWith(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
