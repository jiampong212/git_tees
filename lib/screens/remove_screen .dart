import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_tee/custom_numeric_formatter.dart';
import 'package:git_tee/data_classes/tshirt.dart';
import 'package:git_tee/database_api.dart';
import 'package:git_tee/screens/login_screen.dart';

class RemoveScreen extends ConsumerWidget {
  const RemoveScreen({Key? key, required this.max}) : super(key: key);

  static final TextEditingController _quantityController = TextEditingController();

  final int max;
  final int min = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _quantityController.text = min.toString();
    _quantityController.selection = TextSelection.fromPosition(TextPosition(offset: min.toString().length));

    return Center(
      child: SizedBox(
        width: 500,
        height: 330,
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
                    'Remove Shirts',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ..._quantity(),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_quantityController.text.isEmpty) {
                          EasyLoading.showError('Invalid quantity');
                          return;
                        }

                        Tshirts _tshirts = ref.read(productProvider);

                        int _originalQuantity = _tshirts.quantity;
                        int _removeQuantity = int.parse(_quantityController.text);

                        await DatabaseAPI(settings: ref.read(mysqlSettingsProvider)).removeShirt(
                          quantity: _originalQuantity - _removeQuantity,
                          productID: _tshirts.productID,
                        );

                        await ref.read(tshirtsProvider.notifier).reset(ref);

                        _clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Remove'),
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

  List<Widget> _quantity() {
    return [
      Row(
        children: [
          const Expanded(
            flex: 1,
            child: Text('Quantity'),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Current quantity: $max',
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: 200,
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp("[0-9]"), allow: true),
                  CustomNumericFormatter(min, max),
                ],
                controller: _quantityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _quantityController.text = max.toString();
                  },
                  child: const Text('Max'),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  _clear() {
    _quantityController.clear();
  }
}
