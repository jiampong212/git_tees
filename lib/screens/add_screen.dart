import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_tee/data_classes/tshirt.dart';
import 'package:git_tee/database_api.dart';
import 'package:git_tee/screens/login_screen.dart';

class AddScreen extends ConsumerWidget {
  const AddScreen({Key? key}) : super(key: key);

  static final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    'Add Shirts',
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
                      onPressed: () async {
                        _clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Tshirts _tshirts = ref.read(productProvider);

                        int _originalQuantity = _tshirts.quantity;
                        int _addQuantity = int.parse(_quantityController.text);

                        await DatabaseAPI().addShirt(
                          quantity: _addQuantity + _originalQuantity,
                          productID: _tshirts.productID,
                        );

                        ref.read(tshirtsProvider.notifier).reset(ref);

                        _clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
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
      const Text('Quantity'),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        width: 200,
        child: TextField(
          inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)],
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
    ];
  }

  _clear() {
    _quantityController.clear();
  }
}
