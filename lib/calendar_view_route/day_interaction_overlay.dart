import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crimson_harvest/non_widget/day.dart';

class DayInteractionOverlay extends StatelessWidget {
  static const String routeDetailView = "/detail_view";
  OverlayEntry overlayEntry;
  late Box boxTR;
  Day day;

  DayInteractionOverlay({required this.overlayEntry, required this.day}){
    openBox();
  }

  Size _calculateButtonSize(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Size(screenWidth/4, screenHeight/10);
  }

  Offset _calculateButtonPosition(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Size buttonSize = _calculateButtonSize(context);

    return Offset(screenWidth - buttonSize.width, screenHeight - buttonSize.height * 2);
  }

  String _getTimeRangeButtonValue(BuildContext context){
    if(day.inTimeRange){
      return AppLocalizations.of(context)?.end ?? "";
    }
    return AppLocalizations.of(context)?.start ?? "";
  }

  void startTimeRange(){
    boxTR.put(day.activeDayKey, "first");
    //boxTR.close();//?
  }

  void endTimeRange(){
    if(boxTR.get(day.activeDayKey) == "first"){
      // kill whole timerange
      boxTR.delete(day.activeDayKey);
    }
    else{
      boxTR.put(day.activeDayKey, "end");
      //boxTR.close();//?
    }
  }

  void openBox() async {
    boxTR = await Hive.openBox('boxTR');
  }


  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _calculateButtonPosition(context).dx,
      top: _calculateButtonPosition(context).dy,
      child: Column(
        children: [
          ElevatedButton(
            child: Text(_getTimeRangeButtonValue(context)),
            onPressed: (){
              if(day.inTimeRange){
                endTimeRange();
              }
              else{
                startTimeRange();
              }
            }, 
            style: ElevatedButton.styleFrom(
              fixedSize: _calculateButtonSize(context),
              padding: EdgeInsets.all(24),
            ),
          ),
          ElevatedButton(
            // size of icon
            child: Icon(Icons.edit_note_outlined),
            onPressed: () {
              overlayEntry.remove();
              Navigator.pushNamed(
                context, 
                routeDetailView,
              );
            }, 
            style: ElevatedButton.styleFrom(
              fixedSize: _calculateButtonSize(context),
            ),
          ),
        ],
      ),
    );
  }
}