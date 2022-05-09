import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '/components/text_form_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static const String routeName = '/';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
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
            CrowdFormField(
              controller: _email, 
              fieldText: 'Email', 
              validator: emailValidate,
              keyboardType: TextInputType.emailAddress,
            ),
            CrowdFormField(
              controller: _password, 
              fieldText: 'Password',  
              validator: passwordValidate,
              isObscure: true,
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: OutlinedButton(
                child: const Text('Login'),
                onPressed: () {
                  //_formKey.currentState!.validate();
                  Navigator.of(context).pushNamed(
                    'main_tab_controller'); //placeholder until we get login working with a post request
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
                child: const Text('Register')
              )
            )
          ]
        )
      )
    );
  }

  //validators
  String? emailValidate(String? email) {
    if (email!.isEmpty) {
      return 'Please enter your email';
    } else if (!EmailValidator.validate(email)) {
      return 'Not a valid email';
    }
    return null;
  }

  String? passwordValidate(String? password) {
    if (password!.isEmpty) {
      return 'Please enter your password';
    } 
    return null;
  }
}
