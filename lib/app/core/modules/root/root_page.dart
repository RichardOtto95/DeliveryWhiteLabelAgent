import 'dart:ui';

import 'package:delivery_agent_white_label/app/core/modules/root/root_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';
import '../splash/splash_module.dart';

class RootPage extends StatefulWidget {
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final RootStore store = Modular.get();

  SingletonFlutterWindow window = WidgetsBinding.instance.window;

  @override
  void initState() {
    super.initState();
    window.onPlatformBrightnessChanged = () => setState(() {
          brightness = window.platformBrightness;
          print("New Brightness: $brightness");
        });
  }

  @override
  Widget build(BuildContext context) {
    colors = ColorScheme(
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
    );
    // colors = brightness == Brightness.light
    //   ? ColorScheme(
    //       brightness: brightness,
    //       primary: primaryLight,
    //       onPrimary: onPrimaryLight,
    //       secondary: secondaryLight,
    //       onSecondary: onSecondaryLight,
    //       error: errorLight,
    //       onError: onErrorLight,
    //       background: backgroundLight,
    //       onBackground: onBackgroundLight,
    //       surface: surfaceLight,
    //       onSurface: onSurfaceLight,
    //       shadow: shadowLight,
    //     )
    //   : ColorScheme(
    //       brightness: brightness,
    //       primary: primaryDark,
    //       onPrimary: primaryDark,
    //       secondary: secondaryDark,
    //       onSecondary: secondaryDark,
    //       error: errorDark,
    //       onError: errorDark,
    //       background: backgroundDark,
    //       onBackground: backgroundDark,
    //       surface: surfaceDark,
    //       onSurface: surfaceDark,
    //       shadow: shadowDark,
    //     );

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
      debugShowCheckedModeBanner: false,
      home: SplashModule(),
    );
  }
}
