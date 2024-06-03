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
    updateList();
    notifyListeners();
  }

  Future<void> removeItem(int index) async {
    // addItemsList.remove(item);
    await MyDatabase().deleteProduct(index);
    updateList();
    notifyListeners();
  }

  Future<void> deleteItem(int index) async {
    await MyDatabase().tempRemoveProduct(index);
    updateList();
    notifyListeners();
  }

  Future<void> updateItem(int index, Map<String, dynamic> item) async {
    // addItemsList[index] = item;
    await MyDatabase().updateProduct(item, index);
    updateList();
    notifyListeners();
  }

  Future<void> restoreItem(int index) async {
    await MyDatabase().restoreProduct(index);
    updateList();
    notifyListeners();
  }

  Future<void> updateDayLeftForAllProducts() async {
    await MyDatabase().updateDayLeftForAllProducts();
    await updateList();
    notifyListeners();
  }
}
