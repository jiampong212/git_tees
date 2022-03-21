import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_tee/data_classes/tshirt.dart';
import 'package:git_tee/database_api.dart';
import 'package:git_tee/screens/login_screen.dart';
import 'package:git_tee/utilites.dart';

class TshirtsProvider extends StateNotifier<List<Tshirts>> {
  TshirtsProvider() : super([]);

  List<Tshirts> _fullList = [];

  Future init(WidgetRef ref) async {
    await DatabaseAPI(settings: ref.read(mysqlSettingsProvider)).queryTable().then(
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

  sortName(bool ascending) {
    if (ascending) {
      state.sort((a, b) {
        return a.productName.compareTo(b.productName);
      });
    } else {
      state.sort((a, b) {
        return b.productName.compareTo(a.productName);
      });
    }
  }

  sortColor(ascending) {
    if (ascending) {
      state.sort(
        (a, b) {
          int aIndex = TshirtColorsEnum.values.indexWhere((element) {
            return element.name == a.color;
          });

          int bIndex = TshirtColorsEnum.values.indexWhere((element) {
            return element.name == b.color;
          });

          return aIndex.compareTo(bIndex);
        },
      );
    } else {
      state.sort(
        (a, b) {
          int aIndex = TshirtColorsEnum.values.indexWhere((element) {
            return element.name == a.color;
          });

          int bIndex = TshirtColorsEnum.values.indexWhere((element) {
            return element.name == b.color;
          });

          return bIndex.compareTo(aIndex);
        },
      );
    }
  }

  sortSize(ascending) {
    if (ascending) {
      state.sort(
        (a, b) {
          int aIndex = TshirtSizeEnum.values.indexWhere((element) {
            return element.name == a.size;
          });

          int bIndex = TshirtSizeEnum.values.indexWhere((element) {
            return element.name == b.size;
          });

          return aIndex.compareTo(bIndex);
        },
      );
    } else {
      state.sort(
        (a, b) {
          int aIndex = TshirtSizeEnum.values.indexWhere((element) {
            return element.name == a.size;
          });

          int bIndex = TshirtSizeEnum.values.indexWhere((element) {
            return element.name == b.size;
          });

          return bIndex.compareTo(aIndex);
        },
      );
    }
  }

  sortQuantity(bool ascending) {
    if (ascending) {
      state.sort((a, b) {
        return a.quantity.compareTo(b.quantity);
      });
    } else {
      state.sort((a, b) {
        return b.quantity.compareTo(a.quantity);
      });
    }
  }

  sortPrice(bool ascending) {
    if (ascending) {
      state.sort((a, b) {
        return a.price.compareTo(b.price);
      });
    } else {
      state.sort((a, b) {
        return b.price.compareTo(a.price);
      });
    }
  }

  sortReleaseDate(bool ascending) {
    if (ascending) {
      state.sort((a, b) {
        return a.lastDateReleased?.compareTo(b.lastDateReleased ?? DateTime(1980)) ?? 0;
      });
    } else {
      state.sort((a, b) {
        return b.lastDateReleased?.compareTo(a.lastDateReleased ?? DateTime(1980)) ?? 0;
      });
    }
  }

  sortReceiveDate(bool ascending) {
    if (ascending) {
      state.sort((a, b) {
        return a.lastDateReceived?.compareTo(b.lastDateReceived ?? DateTime(1980)) ?? 0;
      });
    } else {
      state.sort((a, b) {
        return b.lastDateReceived?.compareTo(a.lastDateReceived ?? DateTime(1980)) ?? 0;
      });
    }
  }
}
