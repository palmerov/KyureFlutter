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
          primary: Color.fromARGB(255, 67, 100, 190),
          onPrimary: Colors.white,
          secondary: Colors.deepOrangeAccent,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Color.fromARGB(255, 43, 43, 43),
          surface: Colors.white,
          onSurface: Color.fromARGB(255, 54, 54, 54)));

  bool get light => theme.brightness == Brightness.light;

  final double borderWidth = 0.5;

  final BorderRadius searchViewRadius =
      const BorderRadius.all(Radius.circular(20));

  final Color _colorPrimaryLight = lightTheme.colorScheme.primary;
  final Color _colorPrimarySmoothLight = const Color.fromARGB(255, 204, 230, 255);
  final double blurOpacity=0.3;

  //Light
  final Color _colorLightSeparatorLine =
      const Color.fromARGB(255, 207, 207, 207);
  final Color _colorLighPassword = const Color.fromARGB(255, 83, 132, 187);
  final Color _colorLighAccount = const Color.fromARGB(255, 97, 151, 106);
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

  Color get colorHint =>
      light ? lightTheme.colorScheme.onBackground.withAlpha(180) : Colors.white;

  Color get colorPrimary =>
      light ? lightTheme.colorScheme.primary : Colors.black;

  Color get colorPrimarySmooth =>
      light ? _colorPrimarySmoothLight : Colors.black;
}
