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
  var _email;
  var _userToken;

  void _getUserInfo() async {
    final SharedPreferences sharedPreferences = 
        await SharedPreferences.getInstance();
    _userId = sharedPreferences.getInt('user_id') as int;
    _email = sharedPreferences.getString('email');
    _userToken = sharedPreferences.getString('user_token');
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
                    _formKey.currentState!.reset();
                    _price.text = "";
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
      'store_id': int.parse(_storeid.text),
      'price': double.parse(_price.text),
      'barcode': int.parse(_barcode.text),
      'upload_date': DateTime.now().toUtc().millisecondsSinceEpoch,
      'on_sale': isChecked,
      'email': _email,
      'tags': _tags.text,
    });
    final token = 'Bearer ' + _userToken;
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': token,
    };
    final http.Response apiResponse = await http.post(
        Uri.parse(UploadScreen.herokuUri + "/users/" + 
            _userId.toString() + "/uploads"),
        headers: headers,
        body: body
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (apiResponse.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successful upload!'),
        duration: Duration(seconds: 2),)
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error with upload'))
      );
    }
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
