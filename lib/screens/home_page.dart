import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_tee/custom_route.dart';
import 'package:git_tee/data_classes/tshirt.dart';
import 'package:git_tee/database_api.dart';
import 'package:git_tee/main.dart';
import 'package:git_tee/screens/add_screen.dart';
import 'package:git_tee/screens/edit_screen.dart';
import 'package:git_tee/screens/login_screen.dart';
import 'package:git_tee/screens/new_product_screen%20.dart';
import 'package:flutter/material.dart';
import 'package:git_tee/screens/remove_screen%20.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  final double _tableHeaderFontSize = 14;
  static final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Git`Tees Inventory'),
        actions: [
          const Center(child: Text('Dark')),
          Switch(
              value: ref.watch(themeProvider) == ThemeMode.light,
              onChanged: (bool _isDark) {
                if (_isDark) {
                  ref.read(themeProvider.state).state = ThemeMode.light;
                } else {
                  ref.read(themeProvider.state).state = ThemeMode.dark;
                }
              }),
          const Center(child: Text('Light')),
          const SizedBox(
            width: 20,
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _search(ref),
                  _table(ref),
                ],
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            _buttons(context, ref),
          ],
        ),
      ),
    );
  }

  Expanded _table(WidgetRef ref) {
    return Expanded(
      flex: 9,
      child: SingleChildScrollView(
        child: DataTable(
          showCheckboxColumn: false,
          showBottomBorder: true,
          columns: _columns(),
          rows: _rows(ref),
        ),
      ),
    );
  }

  List<DataRow> _rows(WidgetRef ref) {
    List<DataRow> _temp = [];

    String selectedID = ref.watch(productProvider).productID;

    ref.watch(tshirtsProvider).forEach(
      (element) {
        _temp.add(
          DataRow(
            selected: element.productID == selectedID,
            onSelectChanged: (selected) {
              ref.watch(productProvider.state).state = element;
            },
            cells: [
              DataCell(SelectableText(element.productID)),
              DataCell(Text(element.productName)),
              DataCell(Text(element.color)),
              DataCell(Text(element.size)),
              DataCell(Text(element.quantity.toString())),
              DataCell(Text(element.priceStringPHP)),
              DataCell(Text(element.lastDateReleasedString)),
              DataCell(Text(element.lastDateReceivedString)),
            ],
          ),
        );
      },
    );

    return _temp;
  }

  List<DataColumn> _columns() {
    return <DataColumn>[
      DataColumn(
        label: Text(
          'Product ID',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: _tableHeaderFontSize),
        ),
      ),
      DataColumn(
        label: Text(
          'Product Name',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: _tableHeaderFontSize),
        ),
      ),
      DataColumn(
        label: Text(
          'Color',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: _tableHeaderFontSize),
        ),
      ),
      DataColumn(
        label: Text(
          'Size',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: _tableHeaderFontSize),
        ),
      ),
      DataColumn(
        label: Text(
          'Quantity',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: _tableHeaderFontSize),
        ),
      ),
      DataColumn(
        label: Text(
          'Price',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: _tableHeaderFontSize),
        ),
      ),
      DataColumn(
        label: Text(
          'Last release date',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: _tableHeaderFontSize),
        ),
      ),
      DataColumn(
        label: Text(
          'Last receive date',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: _tableHeaderFontSize),
        ),
      ),
    ];
  }

  Expanded _search(WidgetRef ref) {
    return Expanded(
      flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Search:'),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            width: 200,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                isDense: true,
                contentPadding: EdgeInsets.all(8.0),
              ),
              controller: _searchController,
              onChanged: (String input) {
                if (input.isEmpty) {
                  ref.read(tshirtsProvider.notifier).clearSearch(ref);
                }
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(tshirtsProvider.notifier).searchForProductID(_searchController.text);
            },
            child: const Text('Search using product ID'),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(tshirtsProvider.notifier).searchForProductName(_searchController.text);
            },
            child: const Text('Search using product name'),
          ),
        ],
      ),
    );
  }

  Expanded _buttons(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                CustomRoute(
                  builder: (context) {
                    return const NewProductScreen();
                  },
                ),
              );
            },
            child: const Text('New Product'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: ref.watch(productProvider) == Tshirts.empty()
                ? null
                : () {
                    Navigator.push(
                      context,
                      CustomRoute(
                        builder: (context) {
                          return const AddScreen();
                        },
                      ),
                    );
                  },
            child: const Text('Add Shirts'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: ref.watch(productProvider) == Tshirts.empty()
                ? null
                : () {
                    Navigator.push(
                      context,
                      CustomRoute(
                        builder: (context) {
                          return RemoveScreen(
                            max: ref.read(productProvider).quantity,
                          );
                        },
                      ),
                    );
                  },
            child: const Text('Remove Shirts'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: ref.watch(productProvider) == Tshirts.empty()
                ? null
                : () {
                    Navigator.push(
                      context,
                      CustomRoute(
                        builder: (context) {
                          return const EditScreen();
                        },
                      ),
                    );
                  },
            child: const Text('Edit Price'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: ref.watch(productProvider) == Tshirts.empty()
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete?'),
                          actions: [
                            TextButton(
                              onPressed: ref.watch(productProvider) == Tshirts.empty()
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                    },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                String productID = ref.read(productProvider).productID;

                                await DatabaseAPI().deleteProduct(productID);
                                await ref.read(tshirtsProvider.notifier).reset(ref);

                                Navigator.pop(context);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
            child: const Text('Delete Product'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.watch(tshirtsProvider.notifier).reset(ref);
            },
            child: const Text('Refresh List'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
