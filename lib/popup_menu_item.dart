import 'package:flutter/material.dart';

enum MenuType { big, oneLine }

abstract class MenuItemProvider {
  String get menuTitle;
  Widget? get menuImage;
  TextStyle get menuTextStyle;
  TextAlign get menuTextAlign;
  Function get clickAction;
}

class MenuItem extends MenuItemProvider {
  Widget? image;
  String title;
  TextStyle textStyle;
  TextAlign textAlign;
  Function press;

  MenuItem({
    this.title = "",
    this.image,
    required this.textStyle,
    required this.textAlign,
    required this.press,
  });

  @override
  Function get clickAction => press;

  @override
  Widget? get menuImage => image;

  @override
  String get menuTitle => title;

  @override
  TextStyle get menuTextStyle => textStyle;

  @override
  TextAlign get menuTextAlign => textAlign;
}

typedef MenuClickCallback = Function(MenuItemProvider item);
