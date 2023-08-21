//before let's add the http package
import 'package:shared_preferences/shared_preferences.dart';
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

  static const int TIME_INTERVAL = 1 * 60 * 1000; // 1 minutes

  //In our tutorial we will only see how to get the live matches
  //make sure to read the api documentation to be ables too understand it

  // you will find your api key in your dashboard
  //so create your account it's free
  //Now let's add the headers


  static const headers = {
    'X-RapidAPI-Key': 'f2b8772660msh28baa77eb6058acp1b2986jsn6d583cb1fb31',
    'X-RapidAPI-Host': 'football-live-score-goal-official.p.rapidapi.com'
  };

  Future<void> _saveDataToCache(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(data);
    prefs.setString(key, jsonData);
    prefs.setInt('${key}_time', DateTime.now().millisecondsSinceEpoch);
  }

  Future<dynamic> _getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(key);
    final cachedTime = prefs.getInt('${key}_time') ?? 0;

    if (jsonData != null && DateTime.now().millisecondsSinceEpoch - cachedTime < TIME_INTERVAL) {
      print("in cache");
      return jsonDecode(jsonData);
    }

    return null;
  }


  //Now we will create our method
  //but before this we need to create our model

  //Now we finished with our Model
  Future<List<SoccerWeek>> getAllMatches(int competitionId, int dayIndex) async {
    String cacheKey = 'all_matches_${competitionId}_${dayIndex}';
    // Une clé unique pour identifier ces données spécifiques dans le cache
    final cachedData = await _getCachedData(cacheKey);  // Vérifiez si des données en cache existent et sont valides

    // Si des données en cache valides existent, utilisez-les
    if (cachedData != null) {
      return (cachedData as List).map((item) => SoccerWeek.fromJson(item)).toList();
    }

    // Sinon, effectuez un appel API
    final Uri apiUrl = Uri.parse("https://football-live-score-goal-official.p.rapidapi.com/api/v1/competition?competition_id=$competitionId");
    Response res = await get(apiUrl, headers: headers);
  print(res.statusCode);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      List<dynamic> matchesList = body['data']['gamesets'];
      List<SoccerWeek> matches = matchesList.map((dynamic item) => SoccerWeek.fromJson(item)).toList();

      // Sauvegardez les nouvelles données dans le cache pour de futures utilisations
      await _saveDataToCache(cacheKey, matchesList);

      return matches;
    } else {
      throw Exception('Failed to fetch data'); // Jette une exception avec un message
    }
  }

}
