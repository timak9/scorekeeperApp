import 'package:flutter/material.dart';
import 'soccermodel.dart';

Widget matchTile(SoccerMatch match) {

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
          child: Text(
            match.goalPen.home != -1 || match.goalPen.away != -1
                ? "${match.goal.home} - ${match.goal.away}, ${match.goalProl.home} - ${match.goalProl.away} (${match.goalPen.home} - ${match.goalPen.away})"
                : match.goalProl.home != -1 || match.goalProl.away != -1
                ? "${match.goal.home} - ${match.goal.away}, ${match.goalProl.home} - ${match.goalProl.away}"
                : match.goal.home != -1 || match.goal.away != -1
                ? "${match.goal.home} - ${match.goal.away}"
                : " - ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
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
        Expanded(
          child: Text(
            match.fixture.status.long == "Played"
                ? "Played"
                : (match.fixture.status.long == "Fixture" || match.fixture.status.long == "Postponed")
                ? match.fixture.date
                : "${match.fixture.status.elapsedTime}'",
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