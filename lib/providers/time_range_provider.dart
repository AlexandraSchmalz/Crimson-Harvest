import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TimeRange with ChangeNotifier{
  bool _timeRangeIsActive = false;
  Box? boxTR;

  bool get timeRangeIsActive => _timeRangeIsActive;
  set timeRangeIsActive(value) {
    _timeRangeIsActive = value;
    notifyListeners();
  }

  TimeRange(){
    openBox();
  }

  void openBox() async {
    boxTR = await Hive.openBox("boxTR");
  }
  
  void startTimeRange(BuildContext context, String activeDayKey){
    //_timeRangeIsActive = true;
    boxTR?.put(activeDayKey, "first");
    notifyListeners();
  }

  void endTimeRange(BuildContext context, String activeDayKey){
    _timeRangeIsActive = false;
    boxTR?.put(activeDayKey, "last");
    notifyListeners();
  }

  // where should i close the box?
}