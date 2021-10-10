import 'package:flutter/material.dart';
import 'package:hackeram/widgets/appbar.dart';

import 'constants.dart';
import 'screens/edit_screen.dart';
import 'screens/photo_screen.dart';
import 'screens/snippets_screen.dart';
import 'widgets/bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: CustomAppBar(),
        body: _getPage(this._currentPage),
        bottomNavigationBar: CodeBottomNavigationBar(
          setPage: (position) {
            setState(() {
              this._currentPage = position;
            });
          },
        ),
      ),
    );
  }

  Widget _getPage(int page) {
    switch (page) {
      case 0:
        return SnippetsScreen();
      case 1:
        return PhotoScreen();
      case 2:
        return EditScreen();
    }
    return SnippetsScreen();
  }
}
