import 'package:expiry_reminder/database/reminder.dart';
import 'package:flutter/material.dart';

class AddItemsProvider extends ChangeNotifier {
  late List<Map<String, dynamic>> addItemsList = [];

  Future<void> updateList() async {
    addItemsList = await MyDatabase().getDataFromProducts();
    notifyListeners();
  }

  Future<void> addItem(Map<String, dynamic> item) async {
    // addItemsList.add(item);
    await MyDatabase().insertDataIntoProducts(item);
    await updateList();
  }

  Future<void> removeItem(int index) async {
    // addItemsList.remove(item);
    await MyDatabase().deleteProduct(index);
    await updateList();
  }

  Future<void> deleteItem(int index) async {
    await MyDatabase().tempRemoveProduct(index);
    await updateList();
  }

  Future<void> updateItem(int index, Map<String, dynamic> item) async {
    // addItemsList[index] = item;
    await MyDatabase().updateProduct(item, index);
    await updateList();
  }

  Future<void> restoreItem(int index) async {
    await MyDatabase().restoreProduct(index);
    await updateList();
  }

  Future<void> updateDayLeftForAllProducts() async {
    await MyDatabase().updateDayLeftForAllProducts();
    await updateList();
  }
}
