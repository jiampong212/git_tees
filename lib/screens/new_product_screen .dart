import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_tee/database_api.dart';
import 'package:git_tee/screens/login_screen.dart';
import 'package:git_tee/utilites.dart';
import 'package:flutter/material.dart';

class NewProductScreen extends ConsumerWidget {
  const NewProductScreen({Key? key}) : super(key: key);

  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _priceController = TextEditingController();
  static final TextEditingController _quantityController = TextEditingController();
  static String _tshirtColor = TshirtColorsEnum.Black.name;
  static String _tshirtSize = TshirtSizeEnum.M.name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> _productName() {
      return [
        const Text('Product Name'),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ];
    }

    List<Widget> _color() {
      return [
        const Text('Color'),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 200,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<TshirtColorsEnum>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
              ),
              isDense: true,
              menuMaxHeight: 300,
              value: TshirtColorsEnum.Black,
              style: const TextStyle(
                fontSize: 12,
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: TshirtColorsEnum.values.map<DropdownMenuItem<TshirtColorsEnum>>(
                (TshirtColorsEnum value) {
                  return DropdownMenuItem<TshirtColorsEnum>(
                    value: value,
                    child: Text(value.name),
                  );
                },
              ).toList(),
              onChanged: (TshirtColorsEnum? newValue) {
                _tshirtColor = newValue?.name ?? _tshirtColor;
              },
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ];
    }

    List<Widget> _size() {
      return [
        const Text('Size'),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 200,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<TshirtSizeEnum>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
              ),
              isDense: true,
              menuMaxHeight: 300,
              value: TshirtSizeEnum.M,
              style: const TextStyle(
                fontSize: 12,
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: TshirtSizeEnum.values.map<DropdownMenuItem<TshirtSizeEnum>>(
                (TshirtSizeEnum value) {
                  return DropdownMenuItem<TshirtSizeEnum>(
                    value: value,
                    child: Text(value.name),
                  );
                },
              ).toList(),
              onChanged: (TshirtSizeEnum? newValue) {
                _tshirtSize = newValue?.name ?? _tshirtSize;
              },
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ];
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

    return Center(
      child: SizedBox(
        width: 500,
        height: 700,
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
                    'New Product',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ..._productName(),
                ..._color(),
                ..._size(),
                ..._price(),
                ..._quantity(),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clear();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        double? _price = double.tryParse(_priceController.text.trim());
                        int? _quantity = int.tryParse(_quantityController.text.trim());

                        if (_quantity == null || _price == null) {
                          EasyLoading.showError('Invalid price or quantity');
                          return;
                        }

                        String _productName = _nameController.text.trim();
                        String _productID = Utils.generateProductID(_productName + _tshirtColor + _tshirtSize);
                        bool? _duplicatesCheck = await DatabaseAPI(settings: ref.read(mysqlSettingsProvider)).checkForDuplicates(_productID);

                        if (_duplicatesCheck == null) {
                          return;
                        }

                        if (_duplicatesCheck == true) {
                          EasyLoading.showError('Product with ID of $_productID already exists');
                          return;
                        }

                        await DatabaseAPI(settings: ref.read(mysqlSettingsProvider)).newProduct(
                          productName: _productName,
                          color: _tshirtColor,
                          size: _tshirtSize,
                          price: _price,
                          quantity: _quantity,
                          productID: _productID,
                        );

                        ref.read(tshirtsProvider.notifier).reset(ref);

                        Navigator.pop(context);
                        _clear();
                      },
                      child: const Text('Enter'),
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

  _clear() {
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();
    _tshirtColor = TshirtColorsEnum.Black.name;
    _tshirtSize = TshirtSizeEnum.M.name;
  }
}
