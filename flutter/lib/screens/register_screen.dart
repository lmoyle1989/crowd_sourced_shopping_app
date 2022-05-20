import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crowd_sourced_shopping_app/components/text_form_field.dart';
import 'package:crowd_sourced_shopping_app/models/user.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);


  static const String routeName = 'register';
  static const herokuUri =
      "https://crowd-sourced-shopping-cs467.herokuapp.com/";

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
              CrowdFormField(
                controller: _firstname, 
                fieldText: 'First Name', 
                errorHeight: 0,
                validator: nameValidate
              ),
              CrowdFormField(
                controller: _lastname, 
                fieldText: 'Last Name', 
                errorHeight: 0,
                validator: nameValidate
              ),
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
              CrowdFormField(
                controller: _passwordConfirm, 
                fieldText: 'Confirm Password', 
                validator: confirmPassValidate,
                isObscure: true, 
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: OutlinedButton(
                  child: const Text('Create Account'),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registering...'),
                        duration: Duration(seconds: 100))
                      );
                      sendPost();
                    }
                  },
                )
              ),
            ]
          )
        )
      ))
    );
  }

  void sendPost() async {
    final body = jsonEncode(<String, String>{
      'fn': _firstname.text,
      'ln': _lastname.text,
      'email': _email.text,
      'password': _password.text,
    });
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final http.Response apiResponse = await http.post(
        Uri.parse(RegisterPage.herokuUri + "/users"),
        headers: headers,
        body: body);
    
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (apiResponse.statusCode == 201) {
      var decode = jsonDecode(apiResponse.body) as Map<String, dynamic>;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successful registration!'),
        duration: Duration(seconds: 2),)
      );
      Navigator.of(context).pop();
    }
    else if (apiResponse.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already registered'))
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error with registration'))
      );
    }
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