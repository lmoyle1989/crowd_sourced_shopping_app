import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  static const String routeName = 'register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop()),
            title: const Text('Create Account'),
            elevation: 0),
        body: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width * .75,
                          child: TextFormField(
                            controller: _username,
                            textAlign: TextAlign.center,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Username',
                              isDense: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a username';
                              } else if (value.length < 4) {
                                return 'Username is too short';
                              }
                            },
                          ))),
                  Center(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                          width: MediaQuery.of(context).size.width * .75,
                          child: TextFormField(
                              controller: _password,
                              obscureText: true,
                              textAlign: TextAlign.center,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Password',
                                  isDense: true),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                }
                              }))),
                  Center(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                          width: MediaQuery.of(context).size.width * .75,
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordConfirm,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Confirm Password',
                                isDense: true),
                            textAlign: TextAlign.center,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please confirm password';
                              } else if (value != _password.text) {
                                return 'Not a Match';
                              }
                            },
                          ))),
                  Padding(
                      padding: const EdgeInsets.all(5),
                      child: OutlinedButton(
                        child: const Text('create account'),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Success')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Try again')));
                          }
                        },
                      )),
                ])));
  }
}
