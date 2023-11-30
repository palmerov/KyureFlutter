import 'package:flutter/material.dart';

class KyTheme extends InheritedWidget {
  final ThemeData theme;

  KyTheme({super.key, required super.child, required this.theme});

  static KyTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KyTheme>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is KyTheme &&
        theme.brightness != oldWidget.theme.brightness;
  }

  static final lightTheme = ThemeData.light().copyWith(
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.blueGrey,
          onPrimary: Colors.white,
          secondary: Colors.deepOrangeAccent,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Color.fromARGB(255, 53, 53, 53),
          surface: Colors.white,
          onSurface: Color.fromARGB(255, 54, 54, 54)));

  bool get light => theme.brightness == Brightness.light;

  final double borderWidth05 = 0.5;
  final double borderWidth03 = 0.3;

  final BorderRadius searchViewRadius =
      const BorderRadius.all(Radius.circular(20));

  final Color _colorPrimaryLight = lightTheme.colorScheme.primary;
  final Color _colorPrimarySmoothLight = Color.fromARGB(255, 192, 214, 226);
  final double blurOpacity=0.6;

  //Light
  final Color _colorLightSeparatorLine =
      const Color.fromARGB(255, 196, 196, 196);
  final Color _colorLighPassword = const Color.fromARGB(255, 59, 120, 190);
  final Color _colorLighAccount = const Color.fromARGB(255, 71, 150, 84);
  final Color _colorLighToastBackground =
      const Color.fromARGB(255, 255, 255, 255);
  final Color _colorLighToastText = const Color.fromARGB(255, 24, 24, 24);

  //Dark
  final Color _colorDarkSeparatorLine = const Color.fromARGB(255, 46, 46, 46);
  final Color _colorDarkPassword = const Color.fromARGB(255, 42, 142, 255);
  final Color _colorDarkAccount = const Color.fromARGB(255, 35, 131, 51);
  final Color _colorDarkToastBackground = const Color.fromARGB(127, 0, 0, 0);
  final Color _colorDarkToastText = const Color.fromARGB(255, 24, 24, 24);

  //Getter
  Color get colorSeparatorLine =>
      light ? _colorLightSeparatorLine : _colorDarkSeparatorLine;

  Color get colorAccount => light ? _colorLighAccount : _colorDarkAccount;

  Color get colorPassword => light ? _colorLighPassword : _colorDarkPassword;

  Color get colorToastBackground =>
      light ? _colorLighToastBackground : _colorDarkToastBackground;

  Color get colorToastText => light ? _colorLighToastText : _colorDarkToastText;

  Color get colorBackground =>
      light ? lightTheme.colorScheme.background : Colors.black;

  Color get colorOnBackground =>
      light ? lightTheme.colorScheme.onBackground : Colors.white;

  Color get colorOnBackgroundOpacity30 => colorOnBackground.withOpacity(0.3);

  Color get colorOnBackgroundOpacity50 => colorOnBackground.withOpacity(0.5);

  Color get colorOnBackgroundOpacity60 => colorOnBackground.withOpacity(0.6);

  Color get colorOnBackgroundOpacity80 => colorOnBackground.withOpacity(0.8);

  Color get colorHint =>
      light ? lightTheme.colorScheme.onBackground.withAlpha(180) : Colors.white;

  Color get colorPrimary =>
      light ? lightTheme.colorScheme.primary : Colors.black;

  Color get colorPrimarySmooth =>
      light ? _colorPrimarySmoothLight : Colors.black;
}
