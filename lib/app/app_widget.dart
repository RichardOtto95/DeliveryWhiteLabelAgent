import 'package:delivery_agent_white_label/app/shared/color_theme.dart';
import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: primaryLight,
          onPrimary: onPrimaryLight,
          secondary: secondaryLight,
          onSecondary: onSecondaryLight,
          error: errorLight,
          onError: onErrorLight,
          background: backgroundLight,
          onBackground: onBackgroundLight,
          surface: surfaceLight,
          onSurface: onSurfaceLight,
          shadow: shadowLight,
        ),
        scaffoldBackgroundColor: backgroundLight,
        shadowColor: shadowLight,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: primaryDark,
          onPrimary: onPrimaryDark,
          secondary: secondaryDark,
          onSecondary: onSecondaryDark,
          error: errorDark,
          onError: onErrorDark,
          background: backgroundDark,
          onBackground: onBackgroundDark,
          surface: surfaceDark,
          onSurface: onSurfaceDark,
          shadow: shadowDark,
        ),
        scaffoldBackgroundColor: backgroundDark,
        shadowColor: shadowDark,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      debugShowCheckedModeBanner: false,
      title: "DeliveryApp",
      initialRoute: "/",
    ).modular();
  }
}
