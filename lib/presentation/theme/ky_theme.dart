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

  static final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color.fromARGB(255, 15, 15, 15),
      drawerTheme: const DrawerThemeData(
          elevation: 0, backgroundColor: Color.fromARGB(255, 26, 26, 26)),
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xff4b73a7),
          onPrimary: Colors.white,
          secondary: Colors.deepOrangeAccent,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Color.fromARGB(255, 15, 15, 15),
          onBackground: Color.fromARGB(255, 238, 238, 238),
          surfaceVariant: Color.fromARGB(255, 15, 15, 15),
          surface: Colors.black,
          onSurface: Color.fromARGB(255, 230, 230, 230)));

  bool get dark => theme.brightness == Brightness.dark;
  final Color _colorPrimarySmoothDark =
      const Color.fromARGB(255, 192, 214, 226);

  static final lightTheme = ThemeData.light().copyWith(
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff325186),
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
  final Color _colorPrimarySmoothLight =
      const Color.fromARGB(255, 192, 214, 226);

  final double blurOpacity = 0.6;

  //Light
  final Color _colorLightSeparatorLine =
      const Color.fromARGB(255, 146, 146, 146);
  final Color _colorLighPassword = const Color.fromARGB(255, 59, 120, 190);
  final Color _colorLighAccount = const Color.fromARGB(255, 71, 150, 84);
  final Color _colorLighToastBackground =
      const Color.fromARGB(255, 255, 255, 255);
  final Color _colorLighToastText = const Color.fromARGB(255, 24, 24, 24);

  //Dark
  final Color _colorDarkSeparatorLine = const Color.fromARGB(255, 59, 59, 59);
  final Color _colorDarkPassword = const Color.fromARGB(255, 42, 142, 255);
  final Color _colorDarkAccount = const Color.fromARGB(255, 35, 131, 51);
  final Color _colorDarkToastBackground = const Color.fromARGB(255, 8, 8, 8);
  final Color _colorDarkToastText = const Color.fromARGB(255, 228, 228, 228);

  //Getter
  Color get colorSeparatorLine =>
      light ? _colorLightSeparatorLine : _colorDarkSeparatorLine;

  Color get colorAccount => light ? _colorLighAccount : _colorDarkAccount;

  Color get colorPassword => light ? _colorLighPassword : _colorDarkPassword;

  Color get colorToastBackground =>
      light ? _colorLighToastBackground : _colorDarkToastBackground;

  Color get colorToastText => light ? _colorLighToastText : _colorDarkToastText;

  Color get colorBackground => light
      ? lightTheme.colorScheme.background
      : darkTheme.colorScheme.background;

  Color get colorOnBackground => light
      ? lightTheme.colorScheme.onBackground
      : darkTheme.colorScheme.onBackground;

  Color get colorOnBackgroundOpacity30 => colorOnBackground.withOpacity(0.3);

  Color get colorOnBackgroundOpacity50 => colorOnBackground.withOpacity(0.5);

  Color get colorOnBackgroundOpacity60 => colorOnBackground.withOpacity(0.6);

  Color get colorOnBackgroundOpacity80 => colorOnBackground.withOpacity(0.8);

  Color get colorHint => light
      ? lightTheme.colorScheme.onBackground.withAlpha(180)
      : darkTheme.colorScheme.onBackground.withAlpha(180);

  Color get colorPrimary =>
      light ? lightTheme.colorScheme.primary : darkTheme.colorScheme.primary;

  Color get colorPrimarySmooth =>
      light ? _colorPrimarySmoothLight : darkTheme.colorScheme.primary;

  get colorError => light ? lightTheme.colorScheme.error : darkTheme.colorScheme.error;
}
