import 'package:flutter/material.dart';

TextTheme _customTextTheme(TextTheme base) {
  return base
      .copyWith(
      headline5: base.headline5!.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 26.0,
  ));
}