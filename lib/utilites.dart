// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

enum TshirtSizeEnum {
  XS,
  S,
  M,
  L,
  XL,
}

enum TshirtColorsEnum {
  Black,
  White,
  Gray,
  Red,
  Orange,
  Yellow,
  Green,
  Blue,
  Violet,
  Maroon,
  Pink,
}

enum TableFieldsEnum {
  color,
  size,
  price,
  last_release_date,
  last_receive_date,
  product_id,
  quantity,
  product_name,
}

class Utils {
  static String generateProductID(String seed) {
    var digest = sha1.convert(utf8.encode(seed));

    String _hash = digest.toString();

    return _hash.substring(0, 7) + _hash.substring(_hash.length - 8, _hash.length);
  }

  static String formatToPHPString(double price) {
    NumberFormat _toPHPString = NumberFormat("###.00#", "en_US");

    return '₱ ${_toPHPString.format(price)}';
  }

  static String formatToString(double price) {
    NumberFormat _toPHPString = NumberFormat("###.00#", "en_US");

    return _toPHPString.format(price);
  }

  static String dateTimeToString(DateTime _dateTime) {
    return '${DateFormat.EEEE().format(_dateTime)} ${DateFormat.yMMMd().format(_dateTime)} ${DateFormat.jm().format(_dateTime)}';
  }
}
