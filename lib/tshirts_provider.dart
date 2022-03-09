import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_tee/data_classes/tshirt.dart';
import 'package:git_tee/database_api.dart';
import 'package:git_tee/screens/login_screen.dart';

class TshirtsProvider extends StateNotifier<List<Tshirts>> {
  TshirtsProvider() : super([]);

  List<Tshirts> _fullList = [];

  Future init(WidgetRef ref) async {
    await DatabaseAPI().queryTable().then(
      (value) {
        List<Tshirts> _temp = [];

        for (var row in value) {
          DateTime? _lastDateReleasedUTC = row[3];
          DateTime? _lastDateReceivedUTC = row[4];

          _temp.add(
            Tshirts(
              color: row[0],
              size: row[1],
              price: row[2],
              lastDateReleased: _lastDateReleasedUTC?.toLocal(),
              lastDateReceived: _lastDateReceivedUTC?.toLocal(),
              productID: row[5],
              quantity: row[6],
              productName: row[7],
            ),
          );
        }
        state = _temp;
        _resetSelectedRow(ref);
        _fullList = state;

      },
    );
  }

  Future reset(WidgetRef ref) async {
    await init(ref);
    _fullList = [];
  }

  _resetSelectedRow(WidgetRef ref) {
    if (state.isNotEmpty) {
      ref.read(productProvider.state).state = state.first;
    } else {
      ref.read(productProvider.state).state = Tshirts.empty();
    }
  }

  searchForProductID(String query) {
    state = _fullList.where((element) {
      return element.productID.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
  }

  searchForProductName(String query) {
    state = _fullList.where((element) {
      return element.productName.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
  }

  clearSearch(WidgetRef ref) {
    state = _fullList;
    _resetSelectedRow(ref);
  }
}
