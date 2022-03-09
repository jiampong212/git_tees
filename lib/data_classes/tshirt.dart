import 'package:git_tee/utilites.dart';

class Tshirts {
  final String color;
  final String size;
  final double price;
  final DateTime? lastDateReleased;
  final DateTime? lastDateReceived;
  final String productID;
  final int quantity;
  final String productName;

  late String priceStringPHP;
  late String lastDateReleasedString;
  late String lastDateReceivedString;
  Tshirts({
    required this.quantity,
    required this.color,
    required this.size,
    required this.price,
    required this.lastDateReleased,
    required this.lastDateReceived,
    required this.productID,
    required this.productName,
  }) {
    priceStringPHP = Utils.formatToPHPString(price);

    if (lastDateReceived != null) {
      lastDateReceivedString = Utils.dateTimeToString(lastDateReceived!);
    } else {
      lastDateReceivedString = 'Not Specified';
    }

    if (lastDateReleased != null) {
      lastDateReleasedString = Utils.dateTimeToString(lastDateReleased!);
    } else {
      lastDateReleasedString = 'Not Specified';
    }
  }

  Tshirts.empty()
      : productID = '',
        quantity = 0,
        size = TshirtSizeEnum.M.name,
        color = TshirtColorsEnum.Black.name,
        lastDateReceived = null,
        lastDateReleased = null,
        price = 0,
        productName = '' {
    priceStringPHP = Utils.formatToPHPString(price);

    if (lastDateReceived != null) {
      lastDateReceivedString = Utils.dateTimeToString(lastDateReceived!);
    } else {
      lastDateReceivedString = 'Not Specified';
    }

    if (lastDateReleased != null) {
      lastDateReleasedString = Utils.dateTimeToString(lastDateReleased!);
    } else {
      lastDateReleasedString = 'Not Specified';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tshirts &&
        other.color == color &&
        other.size == size &&
        other.price == price &&
        other.lastDateReleased == lastDateReleased &&
        other.lastDateReceived == lastDateReceived &&
        other.productID == productID &&
        other.quantity == quantity &&
        other.productName == productName &&
        other.priceStringPHP == priceStringPHP &&
        other.lastDateReleasedString == lastDateReleasedString &&
        other.lastDateReceivedString == lastDateReceivedString;
  }

  @override
  int get hashCode {
    return color.hashCode ^
        size.hashCode ^
        price.hashCode ^
        lastDateReleased.hashCode ^
        lastDateReceived.hashCode ^
        productID.hashCode ^
        quantity.hashCode ^
        productName.hashCode ^
        priceStringPHP.hashCode ^
        lastDateReleasedString.hashCode ^
        lastDateReceivedString.hashCode;
  }
}
