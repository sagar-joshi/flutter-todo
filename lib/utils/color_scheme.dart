import 'package:flutter/material.dart';

class ColorPalette {
  ColorPalette(
      {this.primary = Colors.blue,
      this.secondary = Colors.amber,
      this.background = Colors.white,
      this.surface = Colors.white,
      this.error = Colors.red,
      this.warn = Colors.red,
      this.onPrimary = Colors.white,
      this.onSecondary = Colors.white,
      this.onBackground = Colors.black,
      this.onSurface = Colors.black,
      this.onError = Colors.white,
      this.onWarn = Colors.white});
  Color primary;
  Color secondary;
  Color background;
  Color surface;
  Color error;
  Color warn;
  Color onPrimary;
  Color onSecondary;
  Color onBackground;
  Color onSurface;
  Color onError;
  Color onWarn;
}

ColorPalette palette = ColorPalette();
