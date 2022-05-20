import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crowd_sourced_shopping_app/components/autocomplete_future.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crowd_sourced_shopping_app/components/text_form_field.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  static const herokuUri =
      "https://crowd-sourced-shopping-cs467.herokuapp.com/";
  static const devUri =
      "http://10.0.2.2:8080";

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _barcode = TextEditingController();
  final TextEditingController _tags = TextEditingController();
  final TextEditingController _storeid = TextEditingController();
  bool isChecked = false;
  int _userId = 0;

  void _getUserInfo() async {
    final SharedPreferences sharedPreferences = 
        await SharedPreferences.getInstance();
    _userId = sharedPreferences.getInt('user_id') as int;
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CrowdFormField(
                controller: _price,
                fieldText: 'Price',
                validator: priceValidate,
                contWidth: 0.4,
                keyboardType: TextInputType.number,
                textAlignment: TextAlign.left,
              ),
              const SizedBox(width: 30),
              Flexible(
                child: Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  side: const BorderSide(width: 1.5),
                  splashRadius: 0,
                ),
              ),
              const Text(
                'On sale',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: TextFormField(
                    controller: _barcode,
                    decoration: InputDecoration(
                      hintText: 'Barcode',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: scanBarcode,
                        icon: const Icon(Icons.camera_alt_outlined)
                      )
                    ),
                    validator: barcodeValidate
                  )
                )
              ),
            ],
          ),
          CrowdFormField(
            controller: _tags,
            fieldText: 'Tags',
            validator: tagsValidate,
            textAlignment: TextAlign.left,
            contWidth: 1.0,
            autocorrect: true,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(6), 
              child: AutoCompleteFuture(storeid: _storeid)
            )
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: OutlinedButton(
                child: const Text('Upload'),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Uploading...'),
                      duration: Duration(seconds: 100))
                    );
                    sendPost();
                  }
                },
              )
            )
          ),
        ]
      )
    );
  }

  void sendPost() async {
    final body = jsonEncode(<String, dynamic>{
      'user_id': _userId,
      'store_id': _storeid.text,
      'price': _price.text,
      'barcode': _barcode.text,
      'upload_date': DateTime.now(),
      'on_sale': isChecked,
    });
  
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final http.Response apiResponse = await http.post(
        Uri.parse(UploadScreen.devUri + "/users" + 
            _userId.toString() + "/uploads"),
        headers: headers,
        body: body
    );
    
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    // if (apiResponse.statusCode == 201) {
    //   var decode = jsonDecode(apiResponse.body) as Map<String, dynamic>;
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Successful registration!'),
    //     duration: Duration(seconds: 2),)
    //   );
    //   Navigator.of(context).pop();
    // }
    // else if (apiResponse.statusCode == 409) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Email already registered'))
    //   );
    // }
    // else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Error with registration'))
    //   );
    // }
  }  

  Future<void> scanBarcode() async {
    String barcode;

    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
          '#000000', 'Cancel', false, ScanMode.BARCODE);
    } on PlatformException {
      barcode = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _barcode.text = barcode;
    });
  }

  //validators
  String? priceValidate(String? price) {
    if (price!.isEmpty) {
      return 'Please enter the price';
    }
    return null;
  }

  String? tagsValidate(String? tags) {
    if (tags!.isEmpty) {
      return 'Please enter one or more tags';
    }
    return null;
  }

  String? barcodeValidate(String? tags) {
    if (tags!.isEmpty) {
      return 'Please enter or scan barcode';
    }
    return null;
  }
}
