import 'package:flutter/material.dart';
import 'package:scorekeeper/AppState.dart';
import 'matchTile.dart'; // Importez d'autres fichiers selon vos besoins
import 'soccermodel.dart';

class PageBody extends StatefulWidget {
  final List<SoccerWeek> allmatches;
  final AppState appState; // Ajoutez le currentDayIndex comme paramètre

  PageBody(this.allmatches, this.appState);

  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  AppState appState = AppState(); // Déclarez currentDayIndex ici



  @override
  void initState() {
    super.initState();
    appState = widget.appState; // Initialisez currentDayIndex ici
  }

  void goToPreviousDay() {
    if (appState.currentDayIndex > 0) {
      setState(() {
        appState.currentDayIndex--;
      });
    }
  }

  void goToNextDay() {
    // Vous pouvez limiter l'action forward en fonction de la logique
    if (appState.currentDayIndex <  widget.allmatches.length-1) {
      setState(() {
        appState.currentDayIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF4373D9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: goToPreviousDay,
                      ),
                      Text("Week: ${widget.allmatches[appState.currentDayIndex].day}"),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: goToNextDay,
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.allmatches[appState.currentDayIndex].allmatches.length,
                      itemBuilder: (context, index) {
                        print(widget.allmatches[appState.currentDayIndex].allmatches[index]);
                        return matchTile(widget.allmatches[appState.currentDayIndex].allmatches[index]);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

