import 'package:flutter/foundation.dart';

class Members extends ChangeNotifier {
  int _maleNum = 1;
  int _femaleNum = 1;

  int _maleIndex = 1;
  int _femaleIndex = 1;

  get maleNum => _maleNum;
  get femaleNum => _femaleNum;
  get maleIndex => _maleIndex;
  get femaleIndex => _femaleIndex;

  void setMaleNum(int _number) {
    _maleNum = _number;
    notifyListeners();
  }

  void setFemaleNum(int _number) {
    _femaleNum = _number;
    notifyListeners();
  }

  void incrementMaleIndex() {
    _maleIndex++;
    notifyListeners();
  }

  void incrementFemaleIndex() {
    _femaleIndex++;
    notifyListeners();
  }

  void resetMaleIndex() {
    _maleIndex = 0;
    notifyListeners();
  }

  void resetFemaleIndex() {
    _femaleIndex = 0;
    notifyListeners();
  }
}
