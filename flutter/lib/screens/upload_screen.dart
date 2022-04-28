import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '/components/text_form_field.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _tags = TextEditingController();
  final TextEditingController _barcode = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldWidget(
                    controller: _price, 
                    fieldText: 'Price', 
                    validator: priceValidate,
                    keyboardType: TextInputType.number,
                    contWidth: 0.65,
                  ),
                  SizedBox(
                    width:35,
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
                  const Text('On sale', style: TextStyle(fontSize: 16),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldWidget(
                    controller: _barcode, 
                    fieldText: 'Barcode number', 
                    validator: tagsValidate, 
                    contWidth: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Scan barcode'),
                      onPressed: scanBarcode
                    )
                  ),
                ],
              ),
              TextFieldWidget(
                controller: _tags, 
                fieldText: 'Tags', 
                validator: tagsValidate, 
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: OutlinedButton(
                  child: const Text('Upload'),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _formKey.currentState!.validate();
                  },
                )
              ),
            ]
          )
        )
      ))
    );
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
