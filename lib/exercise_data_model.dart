import 'package:flutter/foundation.dart';

class ExerciseDataModel extends ChangeNotifier {
  Map<String, String> _overlayData = {};

  Map<String, String> get overlayData => _overlayData;

  void updateData(String key, String value) {
    _overlayData[key] = value;
    notifyListeners();
  }

  // Define the loadData method
  void loadData(Map<String, String> newData) {
    _overlayData = Map.from(newData); // Safely copy newData into _overlayData
    notifyListeners();
  }
}
