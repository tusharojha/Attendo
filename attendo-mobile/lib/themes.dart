import 'package:flutter/material.dart';

class Themes {
  static ThemeData themes(BuildContext context) => ThemeData(
      appBarTheme: AppBarTheme(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      textTheme: TextTheme(
        headline4:
            TextStyle(color: navyblueshade1, fontWeight: FontWeight.w500),
      ));

  static Color navyblueshade1 = Color(0xff1C223A);
  static Color blueTColor = Color(0xff1DA1F2);
}
