import 'package:flutter/material.dart';
import 'UserPage.dart';
import 'PageBody.dart';
import 'AppState.dart';
import 'soccermodel.dart';

class scoreMain extends StatefulWidget {
  final List<SoccerWeek> allmatches;
  final AppState appState;

  scoreMain(this.allmatches, this.appState);

  @override
  _scoreMainState createState() => _scoreMainState();
}

class _scoreMainState extends State<scoreMain> {
  int _currentIndex = 0;
  final List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    _children.add(UserPage(widget.allmatches, widget.appState));
    _children.add(PageBody(widget.allmatches, widget.appState));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Score',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Live Score',
          ),
        ],
      ),
    );
  }
}
