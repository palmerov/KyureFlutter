import 'package:flutter/widgets.dart';

class KyBackgrounds {
  static Widget? _gradientSunset;

  static Widget get gradientSunset {
    _gradientSunset ??= Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [
          Color(0xff08113b),
          Color(0xff21083b),
          Color(0xff4f000e),
          Color(0xff641f00),
        ])));
    return _gradientSunset!;
  }
}
