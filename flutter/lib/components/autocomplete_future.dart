import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/models/store.dart';
import 'package:http/http.dart' as http;

class AutoCompleteFuture extends StatefulWidget {
  const AutoCompleteFuture({Key? key}) : super(key: key);

  @override
  State<AutoCompleteFuture> createState() => _AutoCompleteFutureState();
}

class _AutoCompleteFutureState extends State<AutoCompleteFuture> {
  late Future<List<Store>?> _storeOptions;
  int? autocompleteSelection;
  bool dataReceived = false;

  @override
  void initState() {
    super.initState();
    _storeOptions = getStores();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<Store>(
      displayStringForOption: (Store element) =>
          "${element.name}, ${element.address}",
      optionsBuilder: (TextEditingValue sName) async {
        final data = await _storeOptions;
        return data!.where((Store element) {
          return "${element.name.toLowerCase()} ${element.address.toLowerCase()}"
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
          AutocompleteOnSelected<Store> onSelected,
          Iterable<Store> storeOptions) {
        return Material(
          elevation: 5,
          child: ListView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: storeOptions.length,
              itemBuilder: (BuildContext context, int index) {
                Store opt = storeOptions.elementAt(index);
                return GestureDetector(
                  onTap: () {
                    onSelected(opt);
                  },
                  child: ListTile(title: Text("${opt.name} ${opt.address}")),
                );
              }),
        );
      },
      onSelected: (Store selectedStore) {
        //String store = "${selectedStore.name} ${selectedStore.address}";
        setState(() {
          autocompleteSelection = selectedStore.id;
        });
      },
    );
  }

  TextFormField autocompleteText(textController, focus, onSubmit) {
    return TextFormField(
        controller: textController,
        focusNode: focus,
        decoration: InputDecoration(
            hintText: 'Select Store',
            border: const OutlineInputBorder(),
            suffix: dataReceived
                ? null
                : const SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ))),
        onChanged: (val) {
          setState(() {
            autocompleteSelection = null;
          });
        },
        onFieldSubmitted: (String val) {
          onSubmit();
        },
        validator: (String? val) {
          if (autocompleteSelection == null) {
            return "please select a store from the list";
          }
          return null;
        });
  }

  Future<List<Store>?> getStores() async {
    String? latitude = '44.5599852';
    String? longitude = '-123.2939011';
    const url_web = "crowd-sourced-shopping-cs467.herokuapp.com";
    Uri uri = Uri.https(
        url_web, '/stores', {'latitude': latitude, 'longitude': longitude});
    http.Response res = await http.get(uri);
    List<dynamic> data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        dataReceived = true;
      });
      return data.map(
        (e) {
          return Store.fromJson(e);
        },
      ).toList();
    }

    return null;
  }
}
