import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData customLightTheme() {
  final ThemeData lightTheme = ThemeData.light();
  return lightTheme.copyWith(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 182, 192, 183),
    ),
    primaryColor: AppColors.white,
    indicatorColor: AppColors.silver,
    scaffoldBackgroundColor: AppColors.silver,
    primaryIconTheme: lightTheme.primaryIconTheme.copyWith(
      color: AppColors.grey,
      size: 20,
    ),
    iconTheme: lightTheme.iconTheme.copyWith(
      color: Colors.blue,
    ),
    backgroundColor: AppColors.white,
    primaryColorDark: AppColors.black,
    buttonTheme: lightTheme.buttonTheme.copyWith(buttonColor: Colors.blueGrey),
    errorColor: Colors.red,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.white),
    appBarTheme: AppBarTheme(
      color: AppColors.silver,
      elevation: 0,
      toolbarTextStyle: const TextTheme(
        headline6: TextStyle(
          color: AppColors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ).bodyText2,
      titleTextStyle: const TextTheme(
        headline6: TextStyle(
          color: AppColors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ).headline6,
      iconTheme: lightTheme.iconTheme.copyWith(
        color: Colors.blue,
      ),
      actionsIconTheme: lightTheme.iconTheme.copyWith(
        color: Colors.blue,
      ),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: AppColors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        color: AppColors.black,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      headline4: TextStyle(
        color: AppColors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: AppColors.grey,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      caption: TextStyle(
        color: AppColors.grey,
      ),
      bodyText2: TextStyle(
        color: AppColors.grey,
      ),
      bodyText1: TextStyle(
        color: AppColors.grey,
      ),
    ),
  );
}

ThemeData customDarkTheme() {
  final ThemeData darkTheme = ThemeData.dark();
  return darkTheme.copyWith(
    primaryColor: AppColors.grey,
    primaryColorDark: AppColors.white,
    indicatorColor: AppColors.silver,
    scaffoldBackgroundColor: AppColors.black,
    iconTheme: darkTheme.iconTheme.copyWith(
      color: Colors.blue,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: AppColors.black,
      toolbarTextStyle: const TextTheme(
        headline6: TextStyle(
          color: AppColors.white,
          fontSize: 20,
        ),
      ).bodyText2,
      titleTextStyle: const TextTheme(
        headline6: TextStyle(
          color: AppColors.white,
          fontSize: 20,
        ),
      ).headline6,
      iconTheme: darkTheme.iconTheme.copyWith(
        color: Colors.blue,
      ),
      actionsIconTheme: darkTheme.iconTheme.copyWith(
        color: Colors.blue,
      ),
    ),
    primaryIconTheme: darkTheme.primaryIconTheme.copyWith(
      color: Colors.blueGrey,
      size: 20,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: AppColors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        color: AppColors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      headline4: TextStyle(
        color: AppColors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: AppColors.grey,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      caption: TextStyle(
        color: AppColors.grey,
      ),
      bodyText2: TextStyle(
        color: AppColors.grey,
      ),
      bodyText1: TextStyle(
        color: AppColors.grey,
      ),
    ),
  );
}
