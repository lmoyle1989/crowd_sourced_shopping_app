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
  final TextEditingController _barcode = TextEditingController();
  final TextEditingController _tags= TextEditingController();
  bool isChecked = false;
  final List<Map<String, String>> _storeOptions = [
    {"name": "safeway", "address": "1234"},
    {"name": "vons", "address": '9876'}
  ];
  String? autocompleteSelection;

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
              padding: const EdgeInsets.all(6), child: getStores())),
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
        ]
      )
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

  RawAutocomplete getStores() {
    return RawAutocomplete<Map>(
      displayStringForOption: (Map element) =>
          "${element["name"]}, ${element["address"]}",
      optionsBuilder: (TextEditingValue sName) {
        return _storeOptions.where((Map<String, String> element) {
          return "${element["name"]} ${element["address"]}"
              .contains(sName.text.toLowerCase());
        });
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textController,
          FocusNode focus,
          VoidCallback onSubmit) {
        return autocompleteText(textController, focus, onSubmit);
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<Map<dynamic, dynamic>> onSelected,
          Iterable<Map<dynamic, dynamic>> storeOptions) {
        return Material(
          elevation: 5,
          child: ListView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: storeOptions.length,
              itemBuilder: (BuildContext context, int index) {
                final Map opt = storeOptions.elementAt(index);
                return GestureDetector(
                  onTap: () {
                    onSelected(opt);
                  },
                  child:
                      ListTile(title: Text("${opt["name"]} ${opt["address"]}")),
                );
              }),
        );
      },
      onSelected: (Map selectedStore) {
        String store = "${selectedStore["name"]} ${selectedStore["address"]}";
        setState(() {
          autocompleteSelection = store;
        });
      },
    );
  }

  TextFormField autocompleteText(textController, focus, onSubmit) {
    return TextFormField(
      controller: textController,
      focusNode: focus,
      decoration: const InputDecoration(
        hintText: 'Select Store',
        border: OutlineInputBorder(),
      ),
      onFieldSubmitted: (String val) {
        onSubmit();
      },
      validator: (String? val) {
        List selected = _storeOptions.map((element) {
          if (val == "${element["name"]} ${element["address"]}") {
            return true;
          }
        }).toList();
        if (!selected.contains(true)) {
          return "No available option selected";
        }
        return null;
      },
    );
  }
}
