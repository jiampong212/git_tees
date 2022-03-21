import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_tee/database_api.dart';
import 'package:git_tee/screens/login_screen.dart';
import 'package:git_tee/utilites.dart';

class EditScreen extends ConsumerWidget {
  const EditScreen({Key? key}) : super(key: key);

  static final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _priceController.text = Utils.formatToString(ref.watch(productProvider).price);

    return Center(
      child: SizedBox(
        width: 500,
        height: 310,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Edit Price',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ..._price(),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        _clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_priceController.text.isEmpty) {
                          EasyLoading.showError('Invalid Price');
                          return;
                        }

                        await DatabaseAPI(settings: ref.read(mysqlSettingsProvider)).editPrice(
                          price: double.parse(_priceController.text),
                          productID: ref.read(productProvider).productID,
                        );

                        ref.read(tshirtsProvider.notifier).reset(ref);
                        _clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _price() {
    return [
      const Text('Price'),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        width: 200,
        child: TextField(
          inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9.]"), allow: true)],
          controller: _priceController,
          decoration: const InputDecoration(
            icon: Text(
              '₱',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            contentPadding: EdgeInsets.all(8.0),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ];
  }

  _clear() {
    _priceController.clear();
  }
}
