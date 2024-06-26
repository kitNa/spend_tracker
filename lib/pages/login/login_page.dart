import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Map<String, dynamic> _formData = <String, dynamic>{};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Коли ви слухаєте потік за допомогою Stream.listen , повертається об’єкт
  // StreamSubscription .
  //Спостерігач за потоком, який перевірятиме чи був вхід успішним.
  late StreamSubscription _subscription;
  bool _isLoggingIn = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscription = Provider.of<FirebaseBloc>(context)
        .loginStatus
        .listen(_onLoginSuccessful, onError: _onLoginError);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _onLoginSuccessful(bool value) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _onLoginError(dynamic msg) async {
    setState(() {
      _isLoggingIn = false;
    });

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Login Failure'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ok'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Spend Tracker'),
        ),
        body: Stack(
          children: <Widget>[
            _LoginForm(
              formKey: _formKey,
              formData: _formData,
              onLogin: _onLogin,
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: _isLoggingIn ? const CircularProgressIndicator() : Container(),
              ),
            ),
          ],
        ));
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _isLoggingIn = true;
    });
    var bloc = Provider.of<FirebaseBloc>(context, listen:false);
    bloc.login(_formData['email'], _formData['password']);
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.formData,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formData;
  final void Function()? onLogin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 40, 20, 0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Email', icon: Icon(Icons.email_outlined)),
              validator: (value) => value!.isEmpty ? 'Required' : null,
              onSaved: (value) => formData['email'] = value,
            ),
            TextFormField(
              obscureText: false,
              decoration: const InputDecoration(
                  labelText: 'Password', icon: Icon(Icons.security)),
              validator: (value) => value!.isEmpty ? 'Required' : null,
              onSaved: (value) => formData['password'] = value,
            ),
            TextButton(
              onPressed: onLogin,
              child: const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
