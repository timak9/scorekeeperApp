import 'package:flutter/material.dart';
import 'package:scorekeeper/AppState.dart';
import 'JsonReader.dart'; // Fichier contenant la fonction readJson
import 'SoccerApp.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic>? originalData;
  List<dynamic>? filteredData;

  void filterSearchResults(String query) {
    print(2);
    if (query.isNotEmpty) {
      List<dynamic> listData = [];
      originalData!.forEach((item) {
        if (item['country'].toLowerCase().contains(query.toLowerCase()) ||
            (item['leagues'] as List).any((league) => (league['name'] as String).toLowerCase().contains(query.toLowerCase()))) {
          listData.add(item);
        }
      });
      setState(() {
        filteredData?.clear();
        filteredData = List.from(listData);
      });
    } else {
      setState(() {
        filteredData = List.from(originalData!);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sélectionnez une ligue"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Rechercher",
              ),
              onChanged: (value) {
                filterSearchResults(value);
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: readJson(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Une erreur s'est produite"),
                  );
                } else if (snapshot.hasData) {
                  originalData = snapshot.data;  // Initialize to the full list
                  if (filteredData == null) {
                    filteredData = List.from(originalData!);
                  }
                  return ListView.builder(
                    itemCount: filteredData?.length ?? 0,
                    itemBuilder: (context, index) {
                      final country = filteredData![index]['country'];
                      final leagues = filteredData![index]['leagues'];
                      return CountryLeaguesSection(
                          country: country, leagues: leagues);
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class CountryLeaguesSection extends StatelessWidget {
  final String country;
  final List<dynamic> leagues;

  CountryLeaguesSection({required this.country, required this.leagues});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            country,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: leagues.length,
            itemBuilder: (context, leagueIndex) {
              final league = leagues[leagueIndex];
              return ListTile(
                title: Text(league['name']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SoccerApp(id: league['id'],name: "${league['country']}: ${league['name']}",appState: AppState()),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
