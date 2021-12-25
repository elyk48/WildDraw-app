import 'package:flutter/material.dart';

ThemeData CustomDataTheme() {
  final base  = ThemeData.dark();
  final mainColor = Colors.black;
  return base.copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        primary: Colors.deepOrange,
      ),
    ),
    cardColor: Color.lerp(mainColor, Colors.white, 0.2),
    cardTheme: base.cardTheme.copyWith(
      shadowColor: Colors.black,
      color: Color.lerp(mainColor, Colors.amber, 1),
      margin: EdgeInsets.all(10),
      elevation: 0.0,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
          side: BorderSide(color: Colors.white, width: 0.2)),
    ),
  );
}