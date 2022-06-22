import 'package:flutter/material.dart';
import 'package:popup_menu_2/popup_menu.dart';
import 'package:popup_menu_2/popup_menu_item.dart';

class ContextualMenu extends StatefulWidget {
  final Widget child;
  final List<MenuItemProvider> items;
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? lineColor;
  final GlobalKey globalKey;
  final Function()? onDismiss;
  final Function(bool)? stateChanged;
  const ContextualMenu({
    required this.globalKey,
    required this.child,
    required this.items,
    this.backgroundColor,
    this.highlightColor,
    this.lineColor,
    this.onDismiss,
    this.stateChanged,
  }) : super(key: globalKey);

  @override
  State<ContextualMenu> createState() => _ContextualMenuState();
}

class _ContextualMenuState extends State<ContextualMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: () {
        var popupMenu = PopupMenu(
          context: context,
          backgroundColor: widget.backgroundColor,
          lineColor: widget.lineColor,
          maxColumn: 3,
          items: widget.items,
          highlightColor: widget.highlightColor,
          stateChanged: widget.stateChanged,
          onDismiss: widget.onDismiss,
        );
        popupMenu.show(widgetKey: widget.globalKey);
      },
    );
  }
}
