import 'package:flutter/material.dart';

class AddItemsProvider extends ChangeNotifier {
  late final List<Map<String, dynamic>> addItemsList = [];

  void addItem(Map<String, dynamic> item) {
    addItemsList.add(item);
    notifyListeners();
  }

  void removeItem(Map<String, dynamic> item) {
    addItemsList.remove(item);
    notifyListeners();
  }

  void updateItem(int index, Map<String, dynamic> item) {
    addItemsList[index] = item;
    notifyListeners();
  }
}
