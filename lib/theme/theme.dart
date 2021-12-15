
import 'package:flutter/material.dart';
import 'text_theme.dart';
ThemeData example() {
  final base  = ThemeData.dark();
  final mainColor = Colors.white60;
  return base.copyWith(
    cardColor: Color.lerp(mainColor, Colors.white, 0.2),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(

        onPrimary: Colors.black38,
        primary: Colors.amber,
      ),
    ),


  );

      
      
      


}