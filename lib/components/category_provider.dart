import 'package:expiry_reminder/database/reminder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _categoryData = [];
  List<String> dropDownMenuCategoryItemsList = [];

  Future<void> fetchData() async {
    _categoryData = await MyDatabase().getDataFromCategory();
    dropDownMenuCategoryItemsList = _categoryData
        .map((category) => category["C_Category"].toString())
        .toList();
    dropDownMenuCategoryItemsList =
        dropDownMenuCategoryItemsList.toSet().toList();
    notifyListeners();
  }

// List<bool> isInUse = List.filled(dropDownMenuReminderItemsList.length, false);

  Future<void> addCategory(String category) async {
    if (category.trim().isNotEmpty) {
      bool categoryExists = false;
      for (var categoryData in await MyDatabase().getDataFromCategory()) {
        if (categoryData["C_Category"].toString().trim() == category.trim()) {
          categoryExists = true;
          break;
        }
      }

      if (!categoryExists) {
        await MyDatabase().insertDataIntoCategory(category.trim());
      }
    }
    notifyListeners();
  }

// Future<void> removeCategory(String category, int index) async {
//   await MyDatabase().deleteCategory(index);
//   dropDownMenuCategoryItemsList.remove(category);
//   notifyListeners();
// }

  Future<void> updateCategory(String category, index) async {
    if (category.trim().isNotEmpty) {
      bool categoryExists = false;
      for (var categoryData in await MyDatabase().getDataFromCategory()) {
        if (categoryData["C_Category"].toString().trim() == category.trim()) {
          categoryExists = true;
          break;
        }
      }

      if (!categoryExists) {
        await MyDatabase().updateCategory(category.trim(), index);
      }
    }
    notifyListeners();
  }

// void updateIsInUse(String category) {
//   isInUse[dropDownMenuCategoryItemsList.indexOf(category)] = true;
// }

// void updateIsNotInUse(String category) {
//   isInUse[dropDownMenuCategoryItemsList.indexOf(category)] = false;
// }

// bool checkIsTrue(String category) {
//   return isInUse[dropDownMenuCategoryItemsList.indexOf(category)];
// }
}
