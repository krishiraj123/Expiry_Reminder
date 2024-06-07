import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'reminder.db');
    return await openDatabase(databasePath);
  }

  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "reminder.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data =
          await rootBundle.load(join('assets/database', 'reminder.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getDataFromCategory() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> data =
        await db.rawQuery("select * from Category_Detail");
    return data;
  }

  Future<void> insertDataIntoCategory(String data) async {
    Database db = await initDatabase();
    Map<String, dynamic> categoryData = {"C_Category": data};
    await db.insert("Category_Detail", categoryData);
    return;
  }

  Future<void> deleteCategory(int index) async {
    Database db = await initDatabase();
    await db.delete("Category_Detail", where: "C_ID = ?", whereArgs: [index]);
    return;
  }

  Future<void> updateCategory(String category, int index) async {
    Database db = await initDatabase();
    Map<String, dynamic> categoryData = {"C_ID": index, "C_Category": category};
    await db.update("Category_Detail", categoryData,
        where: "C_ID = ?", whereArgs: [index]);
    return;
  }

  Future<List<Map<String, dynamic>>> getDataFromProducts() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> data =
        await db.rawQuery("select * from Product_Detail");
    return data;
  }

  Future<void> insertDataIntoProducts(Map<String, dynamic> data) async {
    Database db = await initDatabase();
    await db.insert("Product_Detail", data);
    return;
  }

  Future<void> deleteProduct(int index) async {
    Database db = await initDatabase();
    await db.delete("Product_Detail", where: "PID = ?", whereArgs: [index]);
    return;
  }

  Future<void> updateProduct(Map<String, dynamic> data, int index) async {
    Database db = await initDatabase();
    await db
        .update("Product_Detail", data, where: "PID = ?", whereArgs: [index]);
    return;
  }

  Future<void> tempRemoveProduct(int index) async {
    Database db = await initDatabase();
    await db.rawUpdate(
      "UPDATE Product_Detail SET isDeleted = ? WHERE PID = ?",
      ["true", index],
    );
  }

  Future<void> restoreProduct(int index) async {
    Database db = await initDatabase();
    await db.rawUpdate(
      "UPDATE Product_Detail SET isDeleted = ? WHERE PID = ?",
      ["false", index],
    );
  }

  Future<void> updateDayLeftForAllProducts() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> products = await getDataFromProducts();

    for (Map<String, dynamic> product in products) {
      Map<String, dynamic> mutableProduct = Map<String, dynamic>.from(product);

      DateTime expiryDate = DateTime.parse(mutableProduct['expiryDate']);
      DateTime now = DateTime.now();
      int dayLeft = (expiryDate.difference(now).inMinutes / 1440).ceil();
      int totalDays = dayLeft + 2;

      if (dayLeft < 0) {
        mutableProduct["dayLeftInExpiryPercent"] = 1.0;
      } else if (dayLeft == 0) {
        mutableProduct["dayLeftInExpiryPercent"] = 1.0;
      } else {
        mutableProduct["dayLeftInExpiryPercent"] = 1 - (dayLeft / totalDays);
      }

      mutableProduct['dayLeftInExpiry'] = dayLeft;
      print(
          'Updating product ID ${mutableProduct['PID']} with days left: $dayLeft');
      await updateProduct(mutableProduct, mutableProduct['PID']);
    }
  }

  Future<List<Map<String, dynamic>>> getProductsToRemind() async {
    Database db = await initDatabase();
    final now = DateTime.now();
    final formattedDate =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return await db.query(
      'Product_Detail',
      where: 'reminderDate <= ? AND isDeleted = ?',
      whereArgs: [formattedDate, 'false'],
    );
  }
}
