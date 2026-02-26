import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:popup_menu_2/popup_menu_item_widget.dart';
import 'package:popup_menu_2/triangle_painter.dart';

import 'popup_menu.dart';

/// Callback triggered when the popup menu's visibility state changes.
typedef PopupMenuStateChanged = void Function(bool isShow);

/// Global configuration for the dimensions of the popup menu items and arrow.
class PopupMenuControl {
  /// The default width of a single menu item.
  static double itemWidth = 72.0;

  /// The default height of a single menu item.
  static double itemHeight = 65.0;

  /// The default height of the arrow pointing to the target widget.
  static double arrowHeight = 10.0;
}

/// A widget that displays a contextual popup menu when tapped.
///
/// The menu is positioned relative to a target widget specified by [targetWidgetKey].
class ContextualMenu extends StatefulWidget {
  /// The child widget that triggers the contextual menu when tapped.
  final Widget child;

  /// The list of items to display in the popup menu.
  final List<ContextPopupMenuItem> items;

  /// The background color of the popup menu.
  final Color? backgroundColor;

  /// The highlight color of a selected popup menu item.
  final Color? highlightColor;

  /// The color of the line separator between menu items.
  final Color? lineColor;

  /// The global key of the target widget to which the popup menu is anchored.
  final GlobalKey targetWidgetKey;

  /// Callback triggered after the popup menu is dismissed.
  final void Function()? onDismiss;

  /// Callback triggered when the menu's visibility state changes.
  final void Function(bool change)? stateChanged;

  /// Whether the menu should dismiss when the user clicks outside of it.
  final bool dismissOnClickAway;

  /// The preferred position of the menu relative to the target widget.
  final PreferredPosition? position;

  /// The maximum number of columns to display in the popup menu grid.
  final int maxColumns;

  /// Creates a [ContextualMenu].
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
    this.position,
  }) : super(key: key);

  @override
  State<ContextualMenu> createState() => ContextualMenuState();
}

class ContextualMenuState extends State<ContextualMenu> {
  OverlayEntry? _entry;

  /// The number of rows in the popup menu grid.
  int _row = 1;

  /// The number of columns in the popup menu grid.
  int _col = 1;

  /// The top-left offset of the popup menu.
  late Offset _offset;

  /// The bounding box of the target widget.
  late Rect _showRect;

  /// Whether the menu is shown below the target widget.
  /// If false, the menu is shown above the widget.
  bool _isDown = true;

  /// Whether the popup menu is currently visible.
  bool _isShow = false;

  /// Returns true if the popup menu is currently visible.
  bool get isShow => _isShow;

  /// The total width of the popup menu.
  double get menuWidth => PopupMenuControl.itemWidth * _col;

  /// The total height of the popup menu, excluding the arrow.
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

  /// Displays the contextual popup menu.
  void show() {
    RenderBox renderBox = widget.targetWidgetKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

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
      builder: (BuildContext context) {
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
    if (widget.position != null) {
      if (widget.position == PreferredPosition.top) {
        // The have not enough space above, show menu under the widget.
        dy = PopupMenuControl.arrowHeight + _showRect.height + _showRect.top;
        _isDown = false;
      } else {
        dy -= PopupMenuControl.arrowHeight;
        _isDown = true;
      }
    } else {
      double top2 = MediaQuery.of(context).padding.top;
      double height2 = AppBar().preferredSize.height;
      if (dy <= top2 + height2) {
        // The have not enough space above, show menu under the widget.
        dy = PopupMenuControl.arrowHeight + _showRect.height + _showRect.top;
        _isDown = false;
      } else {
        dy -= PopupMenuControl.arrowHeight;
        _isDown = true;
      }
    }

    return Offset(dx, dy);
  }

  LayoutBuilder buildPopupMenuLayout(Offset offset) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
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
              top: _isDown ? offset.dy + menuHeight : offset.dy - PopupMenuControl.arrowHeight,
              child: CustomPaint(
                size: Size(15.0, PopupMenuControl.arrowHeight),
                painter: TrianglePainter(isDown: _isDown, color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface),
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
                          color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
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
    List<Widget> rows = <Widget>[];
    for (int i = 0; i < _row; i++) {
      Color color = (i < _row - 1 && _row != 1) ? widget.lineColor ?? Colors.grey : Colors.transparent;
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
    List<Widget> itemWidgets = <Widget>[];
    int i = 0;
    for (ContextPopupMenuItem item in subItems) {
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
      backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
      highlightColor: widget.highlightColor ?? Theme.of(context).colorScheme.error,
    );
  }

  /// Handles the click event on a menu item.
  Future<void> itemClicked(ContextPopupMenuItem item) async {
    await item.onTap?.call();
    dismiss();
  }

  /// Dismisses the contextual popup menu.
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
