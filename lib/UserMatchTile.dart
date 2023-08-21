import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'soccermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _saveScore(String matchId, String score) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(matchId, score);
}
Future<int?> _getSavedScore(String matchId, String suffix) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt("$matchId$suffix");
}



Widget UserMatchTile(SoccerMatch match, TextEditingController homeScoreController, TextEditingController awayScoreController) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            match.home.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child:FutureBuilder<int?>(
            future: _getSavedScore("${match.fixture.id}", "_home"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              homeScoreController.text = snapshot.data?.toString() ?? "";
              return match.fixture.status.long == "Played" || match.fixture.status.long == "Playing"
                  ? Text(snapshot.data?.toString() ?? " - ")
                  : TextField(
                controller: homeScoreController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              );
            },
          )

          ,
        )
        ),
        Text(" - "),
        Expanded(
  child: Center(
  child:FutureBuilder<int?>(
            future: _getSavedScore("${match.fixture.id}", "_away"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              awayScoreController.text = snapshot.data?.toString() ?? "";
              return match.fixture.status.long == "Played" || match.fixture.status.long == "Playing"
                  ? Text(snapshot.data?.toString() ?? " - ")
                  : TextField(
                controller: awayScoreController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              );
            },
          )
          ,
        )
        ),
        Expanded(
          child: Text(
            match.away.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    ),
  );
}
