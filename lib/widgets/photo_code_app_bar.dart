import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class PhotoCodeAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool showBackButton;
  final String title;

  PhotoCodeAppBar({this.showBackButton = false, this.title = "CamCoder"});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: this.showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null
      ),
      
      title: Text(
        title,
        style: TextStyle(
          fontSize: 30,
          color: Constants.accentColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'QuickSand',
        ),
      ),
      centerTitle: true,
      backgroundColor: Constants.barBackgroundColor,
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}
