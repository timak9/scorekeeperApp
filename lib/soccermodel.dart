import 'dart:typed_data';

class SoccerMatch {
  //here we will see the different data
  //you will find every thing you need in the doc
  //I'm not going to use every data, just few ones

  Fixture fixture;
  Team home;
  Team away;
  Goal goal;
  GoalProl goalProl;
  GoalPen goalPen;
  SoccerMatch(this.fixture, this.home, this.away, this.goal,this.goalProl,this.goalPen);

  factory SoccerMatch.fromJson(Map<String, dynamic> json) {
    return SoccerMatch(
        Fixture.fromJson(json),
        Team.fromJson(json['team_A']),
        Team.fromJson(json['team_B']),
        Goal.fromJson(json),
        GoalProl.fromJson(json),
        GoalPen.fromJson(json));
  }
}

class SoccerWeek {
  String day;
  List<SoccerMatch> allmatches;

  SoccerWeek(this.day, this.allmatches);

  factory SoccerWeek.fromJson(Map<String, dynamic> json) {
    List<SoccerMatch> matchesList = (json['matches'] as List)
        .map((matchJson) => SoccerMatch.fromJson(matchJson))
        .toList();
    return SoccerWeek(json['name'], matchesList);
  }
}





//here we will store the fixture
class Fixture {
  int id;
  String date;
  Status status;
  Fixture(this.id, this.date, this.status);

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(json['id'], json['date_time_utc'], Status.fromJson(json));
  }
}

//here we will store the Status
class Status {
  int elapsedTime;
  String long;
  Status(this.elapsedTime, this.long);

  factory Status.fromJson(Map<String, dynamic> json) {
    int minutes = json.containsKey('minute') ? json['minute'] : -1;
    return Status(minutes, json['status']);
  }
}

//here we will store the Team data
class Team {
  int id;
  String name;
  String logoUrl;
  bool winner;
  Team(this.id, this.name, this.logoUrl, this.winner);

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(json['id'], json['name'], json['tla_name'], false);
  }
}

//here we will store the Goal data
class Goal {
  int home;
  int away;
  Goal(this.home, this.away);

  //Now we will create a factory method to copy the data from
  // the json file
  factory Goal.fromJson(Map<String, dynamic> json) {
    int home = json.containsKey('fts_A') ? json['fts_A'] : -1;
    int away = json.containsKey('fts_B') ? json['fts_B'] : -1;
    return Goal(home, away);
  }

  factory Goal.from1Byte(Uint8List data) {
    if (data.length < 1) {
      return Goal(0, 0);
    }
    int combined = data[0];  // Convertir le Uint8List en entier 8 bits
    // Extraire les 4 bits de poids fort et les 4 bits de poids faible
    int home = (combined & 0xF0) >> 4;  // Masquer avec 0xF0 et décaler 4 bits à droite
    int away = combined & 0x0F;  // Masquer avec 0x0F
    return Goal(home, away);
  }

  Uint8List create1Byte() {

    // Créez l'entier 8 bits à partir des deux entiers 4 bits
    int combined = (this.home << 4) | this.away;  // Décalez 'a' de 4 bits vers la gauche et faites un OU avec 'b'

    // Créez le Uint8List
    Uint8List uint8List = Uint8List.fromList([combined]);

    return uint8List;
  }
}

class GoalProl {
  int home;
  int away;
  GoalProl(this.home, this.away);

  //Now we will create a factory method to copy the data from
  // the json file
  factory GoalProl.fromJson(Map<String, dynamic> json) {
    int home = json.containsKey('ets_A') ? json['ets_A'] : -1;
    int away = json.containsKey('ets_B') ? json['ets_B'] : -1;
    return GoalProl(home, away);
  }
}

class GoalPen {
  int home;
  int away;
  GoalPen(this.home, this.away);

  //Now we will create a factory method to copy the data from
  // the json file
  factory GoalPen.fromJson(Map<String, dynamic> json) {
    int home = json.containsKey('ps_A') ? json['ps_A'] : -1;
    int away = json.containsKey('ps_B') ? json['ps_B'] : -1;
    return GoalPen(home, away);
  }
}