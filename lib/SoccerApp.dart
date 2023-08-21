import 'package:flutter/material.dart';
import 'package:scorekeeper/api_manager.dart';
import 'pagebody.dart'; // N'oubliez pas d'importer pagebody.dart si nécessaire
import 'package:scorekeeper/AppState.dart';



class SoccerApp extends StatefulWidget {
  final int id;  // Déclaration de la variable id
  final AppState appState;  // Passer l'instance d'appState ici

  SoccerApp({required this.id, required this.appState});

  @override
  _SoccerAppState createState() => _SoccerAppState(appState: appState);
}

class _SoccerAppState extends State<SoccerApp> {
  final AppState appState;
  _SoccerAppState({required this.appState});

  // void goToPreviousDay() {
  //   setState(() {
  //     if (appState.currentDayIndex > 0) {
  //       appState.currentDayIndex--;
  //     }
  //   });
  // }
  //
  // void goToNextDay() {
  //   setState(() {
  //     // Vous pouvez limiter l'action forward en fonction de la logique
  //     appState.currentDayIndex++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    print(this.appState.currentDayIndex);
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0.0,
        title: Text(
          "SOCCERBOARD",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            // Ceci déclenchera une nouvelle requête et la page sera reconstruite
          });
        },
        child: FutureBuilder(
          future: SoccerApi().getAllMatches(widget.id, appState.currentDayIndex),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("No data available"),
              );
            } else {
              return PageBody(snapshot.data!, appState);
            }
          },
        ),
      ),
    );
  }
}
