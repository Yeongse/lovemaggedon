import 'package:flutter/foundation.dart';

class Members extends ChangeNotifier {
  int _maleNum = 1;
  int _femaleNum = 1;

  get maleNum => _maleNum;
  get femaleNum => _femaleNum;

  void setMaleNum(int _number) {
    _maleNum = _number;
    notifyListeners();
  }

  void setFemaleNum(int _number) {
    _femaleNum = _number;
    notifyListeners();
  }
}
