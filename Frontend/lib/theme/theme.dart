import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4CD964),
      surfaceTint: Color(0xff39693b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffbaf0b7),
      onPrimaryContainer: Color(0xff215026),
      secondary: Color(0xff495361),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd2e4ff),
      onSecondaryContainer: Color(0xff1a4975),
      tertiary: Color(0xff336940),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffb5f1bd),
      onTertiaryContainer: Color(0xff19512a),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xffEFEFEF),
      onSurface: Color(0xff171d1e),
      onSurfaceVariant: Color(0xff41484d),
      outline: Color(0xff71787d),
      outlineVariant: Color(0xffc0c7cd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inversePrimary: Color(0xff9fd49c),
      primaryFixed: Color(0xffbaf0b7),
      onPrimaryFixed: Color(0xff002106),
      primaryFixedDim: Color(0xff9fd49c),
      onPrimaryFixedVariant: Color(0xff215026),
      secondaryFixed: Color(0xffd2e4ff),
      onSecondaryFixed: Color(0xff001d36),
      secondaryFixedDim: Color(0xffa1cafd),
      onSecondaryFixedVariant: Color(0xff1a4975),
      tertiaryFixed: Color(0xffb5f1bd),
      onTertiaryFixed: Color(0xff00210b),
      tertiaryFixedDim: Color(0xff99d4a2),
      onTertiaryFixedVariant: Color(0xff19512a),
      surfaceDim: Color(0xffF8F8FA),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee3e5),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0d3f17),
      surfaceTint: Color(0xff39693b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff477849),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003862),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff46709e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff013f1b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff42794e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff0c1213),
      onSurfaceVariant: Color(0xff30373c),
      outline: Color(0xff4c5359),
      outlineVariant: Color(0xff676e73),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inversePrimary: Color(0xff9fd49c),
      primaryFixed: Color(0xff477849),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff2f5f33),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff46709e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2c5784),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff42794e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff285f37),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc2c7c9),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe3e9ea),
      surfaceContainerHigh: Color(0xffd8dedf),
      surfaceContainerHighest: Color(0xffcdd3d4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00340d),
      surfaceTint: Color(0xff39693b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff235328),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002d52),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff1e4b77),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003415),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1b532d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff262d32),
      outlineVariant: Color(0xff434a4f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inversePrimary: Color(0xff9fd49c),
      primaryFixed: Color(0xff235328),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff083b13),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff1e4b77),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00345d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff1b532d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003c19),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4babb),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf2f3),
      surfaceContainer: Color(0xffdee3e5),
      surfaceContainerHigh: Color(0xffcfd5d6),
      surfaceContainerHighest: Color(0xffc2c7c9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9fd49c),
      surfaceTint: Color(0xff9fd49c),
      onPrimary: Color(0xff053911),
      primaryContainer: Color(0xff215026),
      onPrimaryContainer: Color(0xffbaf0b7),
      secondary: Color(0xffa1cafd),
      onSecondary: Color(0xff003259),
      secondaryContainer: Color(0xff1a4975),
      onSecondaryContainer: Color(0xffd2e4ff),
      tertiary: Color(0xff99d4a2),
      onTertiary: Color(0xff003917),
      tertiaryContainer: Color(0xff19512a),
      onTertiaryContainer: Color(0xffb5f1bd),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffdee3e5),
      onSurfaceVariant: Color(0xffc0c7cd),
      outline: Color(0xff8b9297),
      outlineVariant: Color(0xff41484d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inversePrimary: Color(0xff39693b),
      primaryFixed: Color(0xffbaf0b7),
      onPrimaryFixed: Color(0xff002106),
      primaryFixedDim: Color(0xff9fd49c),
      onPrimaryFixedVariant: Color(0xff215026),
      secondaryFixed: Color(0xffd2e4ff),
      onSecondaryFixed: Color(0xff001d36),
      secondaryFixedDim: Color(0xffa1cafd),
      onSecondaryFixedVariant: Color(0xff1a4975),
      tertiaryFixed: Color(0xffb5f1bd),
      onTertiaryFixed: Color(0xff00210b),
      tertiaryFixedDim: Color(0xff99d4a2),
      onTertiaryFixedVariant: Color(0xff19512a),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1e),
      surfaceContainer: Color(0xff1b2122),
      surfaceContainerHigh: Color(0xff252b2c),
      surfaceContainerHighest: Color(0xff303637),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb4eab1),
      surfaceTint: Color(0xff9fd49c),
      onPrimary: Color(0xff002d0a),
      primaryContainer: Color(0xff6a9d6a),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc7deff),
      onSecondary: Color(0xff002747),
      secondaryContainer: Color(0xff6b93c4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffafebb7),
      onTertiary: Color(0xff002d11),
      tertiaryContainer: Color(0xff659d6f),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd6dde3),
      outline: Color(0xffacb3b9),
      outlineVariant: Color(0xff8a9197),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inversePrimary: Color(0xff225227),
      primaryFixed: Color(0xffbaf0b7),
      onPrimaryFixed: Color(0xff001603),
      primaryFixedDim: Color(0xff9fd49c),
      onPrimaryFixedVariant: Color(0xff0d3f17),
      secondaryFixed: Color(0xffd2e4ff),
      onSecondaryFixed: Color(0xff001225),
      secondaryFixedDim: Color(0xffa1cafd),
      onSecondaryFixedVariant: Color(0xff003862),
      tertiaryFixed: Color(0xffb5f1bd),
      onTertiaryFixed: Color(0xff001505),
      tertiaryFixedDim: Color(0xff99d4a2),
      onTertiaryFixedVariant: Color(0xff013f1b),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff3f4647),
      surfaceContainerLowest: Color(0xff040809),
      surfaceContainerLow: Color(0xff191f20),
      surfaceContainer: Color(0xff23292a),
      surfaceContainerHigh: Color(0xff2d3435),
      surfaceContainerHighest: Color(0xff393f40),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc7fec3),
      surfaceTint: Color(0xff9fd49c),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff9bd099),
      onPrimaryContainer: Color(0xff000f02),
      secondary: Color(0xffe8f0ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff9dc6f9),
      onSecondaryContainer: Color(0xff000c1c),
      tertiary: Color(0xffc2ffc9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff96d09e),
      onTertiaryContainer: Color(0xff000f03),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeaf1f7),
      outlineVariant: Color(0xffbdc3c9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inversePrimary: Color(0xff225227),
      primaryFixed: Color(0xffbaf0b7),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff9fd49c),
      onPrimaryFixedVariant: Color(0xff001603),
      secondaryFixed: Color(0xffd2e4ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffa1cafd),
      onSecondaryFixedVariant: Color(0xff001225),
      tertiaryFixed: Color(0xffb5f1bd),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff99d4a2),
      onTertiaryFixedVariant: Color(0xff001505),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff4b5152),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b2122),
      surfaceContainer: Color(0xff2b3133),
      surfaceContainerHigh: Color(0xff363c3e),
      surfaceContainerHighest: Color(0xff424849),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
