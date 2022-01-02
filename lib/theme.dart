import 'package:flutter/material.dart';

ThemeData CustomDataTheme() {
  final base  = ThemeData.dark();
  const mainColor = Colors.black;
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
      color: Color.lerp(mainColor, Colors.amber.withAlpha(1), 1),
      margin: EdgeInsets.all(15.0),
      elevation: 0.0,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
          //side: BorderSide(color: Colors.brown, width: 1)
      ),
    ),
  );
}

