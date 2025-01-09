import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:popup_menu_2/popup_menu_item_widget.dart';
import 'package:popup_menu_2/triangle_painter.dart';

typedef PopupMenuStateChanged = void Function(bool isShow);

class PopupMenuControl {
  static double itemWidth = 72.0;
  static double itemHeight = 65.0;
  static double arrowHeight = 10.0;
}

class ContextualMenu extends StatefulWidget {
  /// the child is a [Widget]
  final Widget child;

  /// list of items
  final List<ContextPopupMenuItem> items;

  /// background of the pop up
  final Color? backgroundColor;

  /// highlight  of the pop up selected item
  final Color? highlightColor;

  /// color  of line separator
  final Color? lineColor;

  /// the key of the targetting pop up
  final GlobalKey targetWidgetKey;

  /// called after dismissing the popup
  final void Function()? onDismiss;

  /// called after an item clicked
  final void Function(bool change)? stateChanged;

  /// chose if dissmiss if user click away
  final bool dismissOnClickAway;

  /// max columns
  final int maxColumns;
  const ContextualMenu({
    Key? key,
    required this.targetWidgetKey,
    required this.child,
    required this.items,
    this.backgroundColor,
    this.highlightColor,
    this.lineColor,
    this.onDismiss,
    this.dismissOnClickAway = true,
    this.stateChanged,
    this.maxColumns = 3,
  }) : super(key: key);

  @override
  State<ContextualMenu> createState() => ContextualMenuState();
}

class ContextualMenuState extends State<ContextualMenu> {
  OverlayEntry? _entry;

  /// row count
  int _row = 1;

  /// col count
  int _col = 1;

  /// The left top point of this menu.
  late Offset _offset;

  /// Menu will show at above or under this rect
  late Rect _showRect;

  /// if false menu is show above of the widget, otherwise menu is show under the widget
  bool _isDown = true;

  /// It's showing or not.
  bool _isShow = false;
  bool get isShow => _isShow;

  /// chose if dissmiss if user click away
  double get menuWidth => PopupMenuControl.itemWidth * _col;

  /// This height exclude the arrow
  double get menuHeight => PopupMenuControl.itemHeight * _row;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        show();
      },
      child: widget.child,
    );
  }

  void show() {
    RenderBox renderBox =
        widget.targetWidgetKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    _showRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );

    _col = _calculateColCount();
    _row = _calculateRowCount();
    _offset = _calculateOffset(context);

    _entry = OverlayEntry(
      builder: (context) {
        return buildPopupMenuLayout(_offset);
      },
    );

    Overlay.of(context).insert(_entry!);
    _isShow = true;

    widget.stateChanged?.call(true);
  }

  Offset _calculateOffset(BuildContext context) {
    double dx = _showRect.left + _showRect.width / 2.0 - menuWidth / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + menuWidth > MediaQuery.of(context).size.width && dx > 10.0) {
      double tempDx = MediaQuery.of(context).size.width - menuWidth - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - menuHeight;
    if (dy <=
        MediaQuery.of(context).padding.top + AppBar().preferredSize.height) {
      // The have not enough space above, show menu under the widget.
      dy = PopupMenuControl.arrowHeight + _showRect.height + _showRect.top;
      _isDown = false;
    } else {
      dy -= PopupMenuControl.arrowHeight;
      _isDown = true;
    }

    return Offset(dx, dy);
  }

  LayoutBuilder buildPopupMenuLayout(Offset offset) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (widget.dismissOnClickAway) {
            dismiss();
          }
        },
        onVerticalDragStart: (DragStartDetails details) {
          if (widget.dismissOnClickAway) {
            dismiss();
          }
        },
        onHorizontalDragStart: (DragStartDetails details) {
          if (widget.dismissOnClickAway) {
            dismiss();
          }
        },
        child: Stack(
          children: <Widget>[
            // triangle arrow
            Positioned(
              left: _showRect.left + _showRect.width / 2.0 - 7.5,
              top: _isDown
                  ? offset.dy + menuHeight
                  : offset.dy - PopupMenuControl.arrowHeight,
              child: CustomPaint(
                size: Size(15.0, PopupMenuControl.arrowHeight),
                painter: TrianglePainter(
                    isDown: _isDown,
                    color: widget.backgroundColor ??
                        Theme.of(context).colorScheme.surface),
              ),
            ),
            // menu content
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: SizedBox(
                width: menuWidth,
                height: menuHeight,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: menuWidth,
                        height: menuHeight,
                        decoration: BoxDecoration(
                          color: widget.backgroundColor ??
                              Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: _createRows(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  List<Widget> _createRows() {
    List<Widget> rows = [];
    for (int i = 0; i < _row; i++) {
      Color color = (i < _row - 1 && _row != 1)
          ? widget.lineColor ?? Colors.grey
          : Colors.transparent;
      Widget rowWidget = Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: color),
          ),
        ),
        height: PopupMenuControl.itemHeight,
        child: Row(
          children: _createRowItems(i),
        ),
      );

      rows.add(rowWidget);
    }

    return rows;
  }

  // item,  row
  List<Widget> _createRowItems(int row) {
    List<ContextPopupMenuItem> subItems = widget.items.sublist(
      row * _col,
      min(row * _col + _col, widget.items.length),
    );
    List<Widget> itemWidgets = [];
    int i = 0;
    for (var item in subItems) {
      itemWidgets.add(
        _createMenuItem(
          item,
          i < (_col - 1),
        ),
      );
      i++;
    }

    return itemWidgets;
  }

  // calculate row count
  int _calculateRowCount() {
    if (widget.items.isEmpty) {
      log('error menu items can not be null');
      return 0;
    }

    int itemCount = widget.items.length;

    if (_calculateColCount() == 1) {
      return itemCount;
    }

    int row = (itemCount - 1) ~/ _calculateColCount() + 1;

    return row;
  }

  // calculate col count
  int _calculateColCount() {
    if (widget.items.isEmpty) {
      log('error menu items can not be null');
      return 0;
    }

    int itemCount = widget.items.length;
    if (widget.maxColumns != 4 && widget.maxColumns > 0) {
      return widget.maxColumns;
    }

    if (itemCount == 4) {
      return 2;
    }

    if (itemCount <= widget.maxColumns) {
      return itemCount;
    }

    if (itemCount == 5) {
      return 3;
    }

    if (itemCount == 6) {
      return 3;
    }

    return widget.maxColumns;
  }

  Widget _createMenuItem(ContextPopupMenuItem item, bool showLine) {
    return MenuItemWidget(
      item: item,
      showLine: showLine,
      clickCallback: itemClicked,
      lineColor: widget.lineColor ?? Colors.grey,
      backgroundColor:
          widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
      highlightColor:
          widget.highlightColor ?? Theme.of(context).colorScheme.error,
    );
  }

  Future<void> itemClicked(ContextPopupMenuItem item) async {
    await item.onTap?.call();
    dismiss();
  }

  void dismiss() {
    if (!_isShow) {
      return;
    }

    _entry?.remove();
    _isShow = false;
    widget.onDismiss?.call();
    widget.stateChanged?.call(false);
  }
}
