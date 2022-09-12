import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:popup_menu_2/popup_menu_item.dart';
import 'popup_menu_item_widget.dart';
import 'triangle_painter.dart';

typedef PopupMenuStateChanged = Function(bool isShow);

class PopupMenu {
  static var itemWidth = 72.0;
  static var itemHeight = 65.0;
  static var arrowHeight = 10.0;
  OverlayEntry? _entry;
  late List<MenuItemProvider> itms;

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

  /// The max column count, default is 4.
  int _maxColumn = 4;

  /// callback
  VoidCallback? dismissCallback;
  PopupMenuStateChanged? stateChangd;

  late Size _screenSize; // 屏幕的尺寸

  /// Cannot be null
  static late BuildContext buildContext;

  /// style
  late Color _backgroundColor;
  late Color _highlightColor;
  late Color _lineColor;

  /// It's showing or not.
  bool _isShow = false;
  bool get isShow => _isShow;

  /// chose if dissmiss if user click away
  late bool dismissOnClickAway;

  PopupMenu({
    required BuildContext context,
    required List<MenuItemProvider> items,
    VoidCallback? onDismiss,
    int maxColumns = 4,
    Color? backgroundColor,
    Color? highlightColor,
    Color? lineColor,
    PopupMenuStateChanged? stateChanged,
    bool? disClickAway,
  }) {
    dismissCallback = onDismiss;
    stateChangd = stateChanged;
    itms = items;
    _maxColumn = maxColumns;
    _backgroundColor = backgroundColor ?? const Color(0xff232323);
    _lineColor = lineColor ?? const Color(0xFFF8F8F8);
    _highlightColor = highlightColor ?? const Color(0x55000000);
    buildContext = context;
    dismissOnClickAway = disClickAway ?? true;
  }

  void show({Rect? rect, GlobalKey? widgetKey, List<MenuItemProvider>? items}) {
    if (rect == null && widgetKey == null) {
      debugPrint("'rect' and 'key' can't be both null");
      return;
    }

    itms = items ?? itms;
    _showRect = rect ?? PopupMenu.getWidgetGlobalRect(widgetKey!);
    _screenSize = window.physicalSize / window.devicePixelRatio;
    dismissCallback = dismissCallback;

    _calculatePosition(PopupMenu.buildContext);

    _entry = OverlayEntry(builder: (context) {
      return buildPopupMenuLayout(_offset);
    });

    Overlay.of(PopupMenu.buildContext)!.insert(_entry!);
    _isShow = true;
    if (stateChangd != null) {
      stateChangd!(true);
    }
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  void _calculatePosition(BuildContext context) {
    _col = _calculateColCount();
    _row = _calculateRowCount();
    _offset = _calculateOffset(PopupMenu.buildContext);
  }

  Offset _calculateOffset(BuildContext context) {
    double dx = _showRect.left + _showRect.width / 2.0 - menuWidth() / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + menuWidth() > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - menuWidth() - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - menuHeight();
    if (dy <= MediaQuery.of(context).padding.top + 10) {
      // The have not enough space above, show menu under the widget.
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isDown = false;
    } else {
      dy -= arrowHeight;
      _isDown = true;
    }

    return Offset(dx, dy);
  }

  double menuWidth() {
    return itemWidth * _col;
  }

  // This height exclude the arrow
  double menuHeight() {
    return itemHeight * _row;
  }

  LayoutBuilder buildPopupMenuLayout(Offset offset) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (dismissOnClickAway) {
            dismiss();
          }
        },
        onVerticalDragStart: (DragStartDetails details) {
          if (dismissOnClickAway) {
            dismiss();
          }
        },
        onHorizontalDragStart: (DragStartDetails details) {
          if (dismissOnClickAway) {
            dismiss();
          }
        },
        child: Stack(
          children: <Widget>[
            // triangle arrow
            Positioned(
              left: _showRect.left + _showRect.width / 2.0 - 7.5,
              top: _isDown ? offset.dy + menuHeight() : offset.dy - arrowHeight,
              child: CustomPaint(
                size: Size(15.0, arrowHeight),
                painter:
                    TrianglePainter(isDown: _isDown, color: _backgroundColor),
              ),
            ),
            // menu content
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: SizedBox(
                width: menuWidth(),
                height: menuHeight(),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: menuWidth(),
                        height: menuHeight(),
                        decoration: BoxDecoration(
                          color: _backgroundColor,
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
      Color color =
          (i < _row - 1 && _row != 1) ? _lineColor : Colors.transparent;
      Widget rowWidget = Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: color),
          ),
        ),
        height: itemHeight,
        child: Row(
          children: _createRowItems(i),
        ),
      );

      rows.add(rowWidget);
    }

    return rows;
  }

  // 创建一行的item,  row 从0开始算
  List<Widget> _createRowItems(int row) {
    List<MenuItemProvider> subItems = itms.sublist(
      row * _col,
      min(row * _col + _col, itms.length),
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
    if (itms.isEmpty) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    int itemCount = itms.length;

    if (_calculateColCount() == 1) {
      return itemCount;
    }

    int row = (itemCount - 1) ~/ _calculateColCount() + 1;

    return row;
  }

  // calculate col count
  int _calculateColCount() {
    if (itms.isEmpty) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    int itemCount = itms.length;
    if (_maxColumn != 4 && _maxColumn > 0) {
      return _maxColumn;
    }

    if (itemCount == 4) {
      // 4个显示成两行
      return 2;
    }

    if (itemCount <= _maxColumn) {
      return itemCount;
    }

    if (itemCount == 5) {
      return 3;
    }

    if (itemCount == 6) {
      return 3;
    }

    return _maxColumn;
  }

  double get screenWidth {
    double width = window.physicalSize.width;
    double ratio = window.devicePixelRatio;
    return width / ratio;
  }

  Widget _createMenuItem(MenuItemProvider item, bool showLine) {
    return MenuItemWidget(
      item: item,
      showLine: showLine,
      clickCallback: itemClicked,
      lineColor: _lineColor,
      backgroundColor: _backgroundColor,
      highlightColor: _highlightColor,
    );
  }

  Future<void> itemClicked(MenuItemProvider item) async {
    item.clickAction();
    await Future.delayed(const Duration(milliseconds: 500));
    dismiss();
  }

  void dismiss() {
    if (!_isShow) {
      /// Remove method should only be called once
      return;
    }

    _entry?.remove();
    _isShow = false;
    if (dismissCallback != null) {
      dismissCallback!();
    }

    if (stateChangd != null) {
      stateChangd!(false);
    }
  }
}
