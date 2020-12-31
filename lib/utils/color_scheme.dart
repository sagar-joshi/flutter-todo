import 'package:flutter/material.dart';

class ColorPalette {
  ColorPalette(
      {this.primary = Colors.blue,
      this.secondary = Colors.amber,
      this.background = Colors.white,
      this.surface = Colors.white,
      this.bars = Colors.blue,
      this.error = Colors.red,
      this.warn = Colors.red,
      this.onPrimary = Colors.white,
      this.onSecondary = Colors.white,
      this.onBackground = Colors.black,
      this.onSurface = Colors.black,
      this.onError = Colors.white,
      this.onWarn = Colors.white,
      this.onBars = Colors.white});
  Color primary;
  Color secondary;
  Color background;
  Color surface;
  Color bars;
  Color error;
  Color warn;
  Color onPrimary;
  Color onSecondary;
  Color onBackground;
  Color onSurface;
  Color onError;
  Color onWarn;
  Color onBars;
}

ColorPalette light = ColorPalette();
ColorPalette dark = ColorPalette(
    background: Colors.grey[800],
    surface: Colors.grey[850],
    bars: Colors.grey[900],
    onBackground: Colors.white,
    onSurface: Colors.white,
    onBars: Colors.white);

ColorPalette palette = light;
