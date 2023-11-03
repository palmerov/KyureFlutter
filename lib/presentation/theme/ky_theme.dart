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

  final double listItemSeparatorHeight = 0.5;

  final BorderRadius searchViewRadius = BorderRadius.all(Radius.circular(16));

  //Light
  final Color _colorLightSeparatorLine =
      const Color.fromARGB(255, 207, 207, 207);
  final Color _colorLighPassword = const Color.fromARGB(255, 51, 110, 179);
  final Color _colorLighAccount = const Color.fromARGB(255, 66, 143, 79);
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
  get colorSeparatorLine =>
      light ? _colorLightSeparatorLine : _colorDarkSeparatorLine;

  get colorAccount => light ? _colorLighAccount : _colorDarkAccount;

  get colorPassword => light ? _colorLighPassword : _colorDarkPassword;

  get colorToastBackground =>
      light ? _colorLighToastBackground : _colorDarkToastBackground;

  get colorToastText => light ? _colorLighToastText : _colorDarkToastText;

  get colorBackground =>
      light ? lightTheme.colorScheme.background : Colors.black;

  get colorOnBackground =>
      light ? lightTheme.colorScheme.onBackground : Colors.white;

  Color get colorHint =>
      light ? lightTheme.colorScheme.onBackground.withAlpha(180) : Colors.white;

  Color get colorPrimary =>
      light ? lightTheme.colorScheme.primary : Colors.black;

      
}
