import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../constants.dart';

class CodeBottomNavigationBar extends StatefulWidget {
  final void Function(int) setPage;

  CodeBottomNavigationBar({@required this.setPage});

  @override
  _CodeBottomNavigationBarState createState() => _CodeBottomNavigationBarState();
}

class _CodeBottomNavigationBarState extends State<CodeBottomNavigationBar> {
  var _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      curve: Curves.bounceInOut,
      currentIndex:_currentIndex,
      items: [
        SalomonBottomBarItem(icon: Icon(Icons.code), title: Text('Saved Code'),selectedColor: Colors.orange,unselectedColor: Colors.white),
        SalomonBottomBarItem(
            icon: Icon(Icons.camera_alt), title: Text('Upload'),selectedColor: Colors.green,unselectedColor: Colors.white)
      ],
      onTap: (i){
        widget.setPage(i);
        setState(() {
          _currentIndex=i;
        });
      },
    );
  }
}
