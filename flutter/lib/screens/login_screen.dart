import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crowd_sourced_shopping_app/components/text_form_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  static const String routeName = 'login';
  static const herokuUri =
      "https://crowd-sourced-shopping-cs467.herokuapp.com/";

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
                  FocusManager.instance.primaryFocus?.unfocus();
                  if(_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logging in...'),
                      duration: Duration(seconds: 100))
                    );
                    sendPost();
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
                child: const Text('Register')
              )
            )
          ]
        )
      )
    );
  }

  void sendPost() async {
    final body = jsonEncode(<String, String>{
      'email': _email.text,
      'password': _password.text,
    });
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final http.Response apiResponse = await http.post(
        Uri.parse(LoginPage.herokuUri + "/login"),
        headers: headers,
        body: body);

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (apiResponse.statusCode == 201) {
      var decoded = jsonDecode(apiResponse.body) as Map<String, dynamic>;
      var token = decoded['user_token'];
      var userid = decoded['user_id'];
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('user_token', token);
      preferences.setInt('user_id', userid);
      Navigator.of(context).pushNamed('main_tab_controller');
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
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
