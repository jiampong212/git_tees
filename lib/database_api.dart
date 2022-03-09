import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:git_tee/utilites.dart';
import 'package:mysql1/mysql1.dart';

class DatabaseAPI {
  final String dbName = 'cpe_211';
  final String tableName = 'tshirt_inventory';

  late final ConnectionSettings settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'angelo',
    password: 'krystelle12',
    db: dbName,
  );

  Future<Iterable> queryTable() async {
    EasyLoading.show();
    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);
      Iterable results = await conn.query(
        '''SELECT 
        `${TableFieldsEnum.color.name}`, 
        `${TableFieldsEnum.size.name}`,
        `${TableFieldsEnum.price.name}`, 
        `${TableFieldsEnum.last_release_date.name}`,
        `${TableFieldsEnum.last_receive_date.name}`,
        `${TableFieldsEnum.product_id.name}`,
        `${TableFieldsEnum.quantity.name}`,
        `${TableFieldsEnum.product_name.name}`
        FROM `$tableName` WHERE 1''',
        [],
      );
      await conn.close();

      EasyLoading.dismiss();

      return results;
    } catch (e) {
      EasyLoading.showError(e.toString());

      return const Iterable.empty();
    }
  }

  Future newProduct({
    required String productName,
    required String color,
    required String size,
    required double price,
    required int quantity,
    required String productID,
  }) async {
    EasyLoading.show();

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);

      await conn.query(
        '''INSERT INTO `$tableName` (
          `${TableFieldsEnum.color.name}`,
          `${TableFieldsEnum.size.name}`,
          `${TableFieldsEnum.price.name}`,
          `${TableFieldsEnum.last_receive_date.name}`,
          `${TableFieldsEnum.last_release_date.name}`,
          `${TableFieldsEnum.product_id.name}`,
          `${TableFieldsEnum.quantity.name}`,
          `${TableFieldsEnum.product_name.name}`
          ) 
          VALUES (?,?,?,?,?,?,?,?)''',
        [
          color,
          size,
          price,
          DateTime.now().toUtc(),
          null,
          productID,
          quantity,
          productName,
        ],
      );

      conn.close();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future addShirt({
    required int quantity,
    required String productID,
  }) async {
    EasyLoading.show();

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);

      await conn.query('UPDATE `$tableName` SET `quantity`=?, `last_receive_date`=? WHERE `product_id`=?', [
        quantity,
        DateTime.now().toUtc(),
        productID,
      ]);

      conn.close();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future removeShirt({
    required int quantity,
    required String productID,
  }) async {
    EasyLoading.show();

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);

      // TODO: release date not updating

      await conn.query('UPDATE `$tableName` SET `last_release_date`=? , `quantity`=? WHERE `product_id` = ?', [
        DateTime.now().toUtc(),
        quantity,
        productID,
      ]);

      conn.close();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future deleteProduct(String productID) async {
    EasyLoading.show();

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);

      await conn.query('DELETE FROM `$tableName` WHERE `product_id` = ?', [productID]);
      await conn.close();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future editPrice({
    required double price,
    required String productID,
  }) async {
    EasyLoading.show();

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);

      await conn.query('UPDATE `$tableName` SET `price`=? WHERE `product_id`=?', [
        price,
        productID,
      ]);

      conn.close();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future<bool?> checkForDuplicates(String productID) async {
    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);

      Iterable results = await conn.query('SELECT * FROM `tshirt_inventory` WHERE `product_id`=?', [productID]);

      conn.close();

      if (results.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
      return null;
    }
  }
}
