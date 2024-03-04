import 'package:flutter/material.dart';
import 'package:popup_menu_2/contextual_menu.dart';

class ContextPopupMenuItem {
  Widget? child;
  Future<void> Function()? onTap;

  ContextPopupMenuItem({
    this.child,
    this.onTap,
  });
}

class MenuItemWidget extends StatefulWidget {
  final ContextPopupMenuItem item;
  final void Function(ContextPopupMenuItem item) clickCallback;

  final bool showLine;
  final Color lineColor;
  final Color backgroundColor;
  final Color highlightColor;

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
  var highlightColor = const Color(0x55000000);
  var color = const Color(0xff232323);
  @override
  void initState() {
    color = widget.backgroundColor;
    highlightColor = widget.highlightColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          color = highlightColor;
        });
      },
      onTapUp: (details) {
        setState(() {
          color = widget.backgroundColor;
        });
      },
      onLongPressEnd: (details) {
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
