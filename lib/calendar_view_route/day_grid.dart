import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../providers/selected_day_provider.dart';
import '../non_widget/day.dart';
import 'package:crimson_harvest/calendar_view_route/day_interaction_overlay.dart';
import 'package:crimson_harvest/providers/time_range_provider.dart';

class DayGrid extends StatelessWidget{
  DayGrid({required Day this.activeDayObject, required this.isGapDay});
  final Day activeDayObject;
  final bool isGapDay;
  late OverlayEntry overlayEntry;

  bool isCurrentDay(){    // function or variable
    DateTime currentDay = DateTime.now();
    //DateTime activeDayDate = DateTime(activeDayObject.year, activeDayObject.monthNum, activeDayObject.day);
    if(currentDay.year == activeDayObject.year && currentDay.month == activeDayObject.monthNum && currentDay.day == activeDayObject.day){
      return true;
    }
    return false;
  }

  bool isInFuture(){
    DateTime currentDay = DateTime.now();
    DateTime activeDayDate = DateTime(activeDayObject.year, activeDayObject.monthNum, activeDayObject.day);

    if(activeDayDate.isAfter(currentDay)){
      return true;
    }
    return false;
  }

  // variable zu oft initialisiert: fix it

  Color chooseColor(BuildContext context){
    bool activeDayObjectIsSelected = context.watch<SelectedDayProvider>().isSelected && context.watch<SelectedDayProvider>().selectedDay == activeDayObject;
    bool inTimeRange = context.watch<TimeRange>().timeRangeIsActive;

    // @TODO later add current day selection
    // @TODO code colours in settings
    if(isGapDay){
      return Colors.white;
    }
    else if(activeDayObjectIsSelected){
      return Colors.deepOrange;
    }
    else if(isCurrentDay()){
      return Colors.pink;
    }
    else if((context.watch<TimeRange>().boxTR?.get(activeDayObject.activeDayKey) == "first" || context.watch<TimeRange>().timeRangeIsActive) && !isInFuture()){   //probably stops one day before: fix it
      // save in Day isInTimerRange
      activeDayObject.isInTimeRange = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        context.watch<TimeRange>().timeRangeIsActive = true;
      });
      return Colors.teal;
    }
    else{
      return Colors.amber;
    }
  }

  void _showOverlay(BuildContext context){
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                overlayEntry.remove();
                context.read<SelectedDayProvider>().removeSelection();
              },
            ),
            DayInteractionOverlay(overlayEntry: overlayEntry, activeDay: activeDayObject),
          ],
        );
      },
    );
    overlayState?.insert(overlayEntry);
  }

  @override
  build(BuildContext context){
    return GestureDetector(
      onTap: () {
        context.read<SelectedDayProvider>().changeSelection(activeDayObject);
        if(!isGapDay){
          _showOverlay(context);
        }
      },
      child: Container(
        color: chooseColor(context),
        child: isGapDay ? const Text('') : Text(activeDayObject.day.toString()),
        // @TODO later add borders, etc StyleStuff
      ),
    );
  }
}