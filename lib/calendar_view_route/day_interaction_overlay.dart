import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DayInteractionOverlay extends StatelessWidget {
  static const String routeDetailView = "/detail_view";
  OverlayEntry overlayEntry;

  DayInteractionOverlay({required this.overlayEntry});

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
    // if ... return AppLocalizations.of(context)?.end ?? "";

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
            onPressed: null, 
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