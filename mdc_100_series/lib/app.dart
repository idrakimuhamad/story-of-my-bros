// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';

import 'supplemental/cut_corners_border.dart';

import 'model/product.dart';

import 'colors.dart';
import 'home.dart';
import 'login.dart';
import 'backdrop.dart';
import 'category_menu_page.dart';

// TODO: Convert ShrineApp to stateful widget (104)
class ShrineApp extends StatefulWidget {
  @override
  _ShrineAppState createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> {
  Category _currentCategory = Category.all;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      // TODO: Change home: to a Backdrop with a HomePage frontLayer (104)
      home: Backdrop(
        // TODO: Pass _currentCategory for frontLayer (104)
        currentCategory: _currentCategory,
        frontLayer: HomePage(
          category: _currentCategory,
        ),
        backLayer: CategoryMenuPage(
          currentCategory: _currentCategory,
          onCategoryTap: _onCategoryTap,
        ),
        frontTitle: Text("DARK SHINE"),
        backTitle: Text("MENU"),
      ),
      // TODO: Make currentCategory field take _currentCategory (104)
      // TODO: Change backLayer field value to CategoryMenuPage (104)
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      // TODO: Add a theme (103)
      theme: _shrineTheme,
    );
  }

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }
}

Route<dynamic> _getRoute(RouteSettings settings) {
  if (settings.name != '/login') {
    return null;
  }

  return MaterialPageRoute<void>(
    settings: settings,
    builder: (BuildContext context) => LoginPage(),
    fullscreenDialog: true,
  );
}

// TODO: Build a Shrine Theme (103)
// host the custom theme data
final ThemeData _shrineTheme = _buildTheme();

// function that return the theme base, copied from ThemeData light,
// and overwrite with our set of colors
ThemeData _buildTheme() {
  // by using .dark the border on focus of input was determined by the accentColor,
  // while .light will use the primary color
  final ThemeData base = ThemeData.light();

  return base.copyWith(
      accentColor: kShrineBlack100,
      primaryColor: kShrineBlack50,
      buttonColor: kShrineAltYellow,
      scaffoldBackgroundColor: kShrineBlack100,
      cardColor: kShrineBlack100,
      textSelectionColor: kShrineBlack50,
      errorColor: kShrineErrorRed,
      hintColor: kShrineBlack50,
      // TODO: Add the text themes (103)
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
      // TODO: Add the icon themes (103)
      primaryIconTheme: base.iconTheme.copyWith(color: kShrineAltYellow),
      // TODO: Decorate the inputs (103)
      inputDecorationTheme: InputDecorationTheme(border: CutCornersBorder()));
}

// TODO: Build a Shrine Text Theme (103)
// function that return the text theme
TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
        ),
        title: base.title.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
          fontFamily: 'Rubik',
          displayColor: kShrineSurfaceWhite,
          bodyColor: kShrineSurfaceWhite);
}