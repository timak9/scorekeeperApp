import 'package:flutter/material.dart';
import 'package:scorekeeper/AppState.dart';
import 'package:scorekeeper/UserMatchTile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'soccermodel.dart';

class UserPage extends StatefulWidget {
  final List<SoccerWeek> allmatches;
  final AppState appState;

  UserPage(this.allmatches, this.appState);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  AppState appState = AppState();
  Map<String, TextEditingController> homeScoreControllers = {};
  Map<String, TextEditingController> awayScoreControllers = {};

  Future<void> _saveScore(String matchId, int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(matchId, score);
  }

  void submitAllScores() {
    homeScoreControllers.forEach((matchId, homeController) {
      String homeScoreText = homeController.text;
      String awayScoreText = awayScoreControllers[matchId]?.text ?? "";

      if (homeScoreText.isNotEmpty) {
        int homeScore = int.parse(homeScoreText);
        int awayScore = awayScoreText.isNotEmpty ? int.parse(awayScoreText) : 0;

        _saveScore("${matchId}_home", homeScore);
        _saveScore("${matchId}_away", awayScore);
      }
      else if (awayScoreText.isNotEmpty) {
        int awayScore = int.parse(awayScoreText);
        int homeScore = homeScoreText.isNotEmpty ? int.parse(homeScoreText) : 0;
        _saveScore("${matchId}_home", homeScore);
        _saveScore("${matchId}_away", awayScore);
      }
    });
  }


  @override
  void initState() {
    super.initState();
    appState = widget.appState;
  }

  void goToPreviousDay() {
    if (appState.currentDayIndex > 0) {
      setState(() {
        appState.currentDayIndex--;
      });
    }
  }

  void goToNextDay() {
    if (appState.currentDayIndex < widget.allmatches.length - 1) {
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
                        String matchId = widget.allmatches[appState.currentDayIndex].allmatches[index].fixture.id.toString();
                        homeScoreControllers[matchId] = TextEditingController();
                        awayScoreControllers[matchId] = TextEditingController();
                        return UserMatchTile(
                          widget.allmatches[appState.currentDayIndex].allmatches[index],
                          homeScoreControllers[matchId]!,
                          awayScoreControllers[matchId]!,
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: submitAllScores,
                    child: Text('Submit All Scores'),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
