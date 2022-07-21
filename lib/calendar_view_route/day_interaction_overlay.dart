import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crimson_harvest/providers/time_range_provider.dart';
import 'package:crimson_harvest/non_widget/day.dart';

class DayInteractionOverlay extends StatelessWidget {
  static const String routeDetailView = "/detail_view";
  OverlayEntry overlayEntry;
  Day activeDay;

  DayInteractionOverlay({required this.overlayEntry, required this.activeDay});

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
    if (activeDay.isInTimeRange){
      return AppLocalizations.of(context)?.end ?? "";
    }
    return AppLocalizations.of(context)?.start ?? "";
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
              if(_getTimeRangeButtonValue(context) == AppLocalizations.of(context)?.start){
                context.read<TimeRange>().startTimeRange(context, activeDay.activeDayKey);
              }
              else{
                context.read<TimeRange>().endTimeRange(context, activeDay.activeDayKey);
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