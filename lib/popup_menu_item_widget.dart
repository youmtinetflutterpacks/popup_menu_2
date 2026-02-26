import 'package:flutter/material.dart';
import 'package:popup_menu_2/contextual_menu.dart';

/// Represents an individual item within a [ContextualMenu].
class ContextPopupMenuItem {
  /// The widget to display for this menu item (e.g., an Icon or Text).
  Widget? child;

  /// The callback to execute when this menu item is tapped.
  Future<void> Function()? onTap;

  /// Creates a [ContextPopupMenuItem].
  ContextPopupMenuItem({
    this.child,
    this.onTap,
  });
}

/// A widget that renders a single [ContextPopupMenuItem] with interaction states.
class MenuItemWidget extends StatefulWidget {
  /// The data model for this menu item.
  final ContextPopupMenuItem item;

  /// The callback triggered when this item is clicked.
  final void Function(ContextPopupMenuItem item) clickCallback;

  /// Whether to display a separator line on the right side of the item.
  final bool showLine;

  /// The color of the separator line.
  final Color lineColor;

  /// The default background color of the item.
  final Color backgroundColor;

  /// The background color of the item when it is pressed or highlighted.
  final Color highlightColor;

  /// Creates a [MenuItemWidget].
  const MenuItemWidget({
    Key? key,
    required this.item,
    this.showLine = false,
    required this.clickCallback,
    required this.lineColor,
    required this.backgroundColor,
    required this.highlightColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MenuItemWidgetState();
  }
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  Color highlightColor = const Color(0x55000000);
  Color color = const Color(0xff232323);
  @override
  void initState() {
    color = widget.backgroundColor;
    highlightColor = widget.highlightColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          color = highlightColor;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          color = widget.backgroundColor;
        });
      },
      onLongPressEnd: (LongPressEndDetails details) {
        setState(() {
          color = widget.backgroundColor;
        });
      },
      onTap: () {
        // widget.item.clickAction();
        widget.clickCallback(widget.item);
      },
      child: Container(
        constraints: BoxConstraints(
          minWidth: PopupMenuControl.itemWidth,
          minHeight: PopupMenuControl.itemHeight,
        ),
        decoration: BoxDecoration(
          color: color,
          border: Border(
            right: BorderSide(
              color: widget.showLine ? widget.lineColor : Colors.transparent,
            ),
          ),
        ),
        child: widget.item.child,
      ),
    );
  }
}
