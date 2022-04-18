import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                    isDense: true,
                  ),
                  textAlign: TextAlign.center,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    }
                  },
                )
              )
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                width: MediaQuery.of(context).size.width * .75,
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                    isDense: true
                  ),
                  textAlign: TextAlign.center,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                  },
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: OutlinedButton(
                child: const Text('login'),
                onPressed: () { 
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Success'))
                    );
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Try again'))
                    );
                  }
                }, 
              )
            ),
            const Text('- or -'),
            Padding(
              padding: const EdgeInsets.all(5),
              child: OutlinedButton(
                onPressed: () { 
                  Navigator.of(context).pushNamed('register');
                },
                child: const Text('register')
              )
            )
          ]
        )
      )
    );
  }
}