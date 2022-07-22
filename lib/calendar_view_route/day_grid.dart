import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/selected_day_provider.dart';
import '../non_widget/day.dart';
import 'package:crimson_harvest/calendar_view_route/day_interaction_overlay.dart';

class DayGrid extends StatelessWidget{
  DayGrid({required Day this.activeDayObject, required this.isGapDay});
  final Day activeDayObject;
  final bool isGapDay;
  late OverlayEntry overlayEntry;

  bool isCurrentDay(){    // function or variable
    DateTime currentDay = DateTime.now();
    if(currentDay.year == activeDayObject.year && currentDay.month == activeDayObject.monthNum && currentDay.day == activeDayObject.day){
      return true;
    }
    return false;
  }

  Color chooseColor(BuildContext context){
    bool activeDayObjectIsSelected = context.watch<SelectedDayProvider>().isSelected && context.watch<SelectedDayProvider>().selectedDay == activeDayObject;

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
            DayInteractionOverlay(overlayEntry: overlayEntry),
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