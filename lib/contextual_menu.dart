import 'package:flutter/material.dart';
import 'package:popup_menu_2/popup_menu.dart';
import 'package:popup_menu_2/popup_menu_item.dart';

class ContextualMenu extends StatefulWidget {
  /// the child is a [Widget]
  final Widget child;

  /// list of items
  final List<MenuItemProvider> items;

  /// background of the pop up
  final Color? backgroundColor;

  /// highlight  of the pop up selected item
  final Color? highlightColor;

  /// color  of line separator
  final Color? lineColor;

  /// context of pop up
  final BuildContext ctx;

  /// the key of the targetting pop up
  final GlobalKey targetWidgetKey;

  /// called after dismissing the popup
  final Function()? onDismiss;

  /// called after an item clicked
  final Function(bool)? stateChanged;

  /// chose if dissmiss if user click away
  final bool dismissOnClickAway;

  /// max columns
  final int maxColumns;
  const ContextualMenu({
    Key? key,
    required this.targetWidgetKey,
    required this.child,
    required this.items,
    required this.ctx,
    this.backgroundColor,
    this.highlightColor,
    this.lineColor,
    this.onDismiss,
    this.dismissOnClickAway = true,
    this.stateChanged,
    this.maxColumns = 3,
  }) : super(key: key);

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
          context: widget.ctx,
          backgroundColor: widget.backgroundColor,
          lineColor: widget.lineColor,
          maxColumns: widget.maxColumns,
          disClickAway: widget.dismissOnClickAway,
          items: widget.items,
          highlightColor: widget.highlightColor,
          stateChanged: widget.stateChanged,
          onDismiss: widget.onDismiss,
        );
        popupMenu.show(widgetKey: widget.targetWidgetKey);
      },
    );
  }
}
