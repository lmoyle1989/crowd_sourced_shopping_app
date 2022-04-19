import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '/components/text_form_field.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  static const String routeName = 'register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();
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
      body: Center(child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFieldWidget(
                controller: _firstname, 
                fieldText: 'First Name', 
                isObscure: false, 
                errorHeight: 0,
                validator: nameValidate
              ),
              TextFieldWidget(
                controller: _lastname, 
                fieldText: 'Last Name', 
                isObscure: false, 
                errorHeight: 0,
                validator: nameValidate
              ),
              TextFieldWidget(
                controller: _email, 
                fieldText: 'Email', 
                isObscure: false, 
                errorHeight: 0.75,
                validator: emailValidate
              ),
              TextFieldWidget(
                controller: _password, 
                fieldText: 'Password', 
                isObscure: true, 
                errorHeight: 0.75, 
                validator: passwordValidate
              ),
              TextFieldWidget(
                controller: _passwordConfirm, 
                fieldText: 'Confirm Password', 
                isObscure: true, 
                errorHeight: 0.75, 
                validator: confirmPassValidate
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: OutlinedButton(
                  child: const Text('Create Account'),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _formKey.currentState!.validate();
                  },
                )
              ),
          ])))));
  }

  //validators
  String? nameValidate(String? name) {
    if (name!.isEmpty) {
      return '';
    } 
    return null;
  }

  String? emailValidate(String? email) {
    if (email!.isEmpty) {
      return 'Please enter an email';
    } else if (!EmailValidator.validate(email)) {
      return 'Not a valid email';
    }
    return null;
  }

  String? passwordValidate(String? password) {
    if (password!.isEmpty) {
      return 'Please enter a password';
    } 
    return null;
  }

  String? confirmPassValidate(String? confPass) {
    if (confPass!.isEmpty) {
      return 'Please confirm your password';
    } else if (confPass != _password.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}