import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:crowd_sourced_shopping_app/components/autocomplete_future.dart';
import '/components/text_form_field.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _barcode = TextEditingController();
  final TextEditingController _tags = TextEditingController();
  bool isChecked = false;

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
                                      icon: const Icon(
                                          Icons.camera_alt_outlined))),
                              validator: barcodeValidate))),
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
              const Flexible(
                  child: Padding(
                      padding: EdgeInsets.all(6), child: AutoCompleteFuture())),
              Flexible(
                  child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: OutlinedButton(
                        child: const Text('Upload'),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _formKey.currentState!.validate();
                        },
                      ))),
            ]));
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
