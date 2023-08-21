//before let's add the http package
import 'dart:convert';

import 'package:http/http.dart';
import 'package:scorekeeper/soccermodel.dart';

class SoccerApi {
  //now let's set our variables
  //first : let's add the endpoint URL
  // we will get all the data from api-sport.io
  // we will just change our endpoint
  //the null means that the match didn't started yet
  //let's fix that



  //In our tutorial we will only see how to get the live matches
  //make sure to read the api documentation to be ables too understand it

  // you will find your api key in your dashboard
  //so create your account it's free
  //Now let's add the headers
  static const headers = {
    'X-RapidAPI-Key': 'f2b8772660msh28baa77eb6058acp1b2986jsn6d583cb1fb31',
    'X-RapidAPI-Host': 'football-live-score-goal-official.p.rapidapi.com'
  };

  //Now we will create our method
  //but before this we need to create our model

  //Now we finished with our Model
  Future<List<SoccerWeek>> getAllMatches(int competitionId, int dayIndex) async {
    final Uri apiUrl = Uri.parse("https://football-live-score-goal-official.p.rapidapi.com/api/v1/competition?competition_id=$competitionId");
    Response res = await get(apiUrl, headers: headers);
    print(res.statusCode);
    var body;

    if (res.statusCode == 200) {
      // this mean that we are connected to the data base
      body = jsonDecode(res.body);
      List<dynamic> matchesList = body['data']['gamesets'];
      //print("Api service: ${body}"); // to debug
      List<SoccerWeek> matches = matchesList
          .map((dynamic item) => SoccerWeek.fromJson(item))
          .toList();
      print(matches);
      return matches;
    }
    else{
      print("icii");
      throw Exception('Failed to fetch data'); // Jette une exception avec un message
    }
  }
}
