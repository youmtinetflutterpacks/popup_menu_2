import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

typedef PopupMenuStateChanged = Function(bool isShow);

class PopupDialog {
  static var itemWidth = 72.0;
  static var itemHeight = 65.0;
  static var arrowHeight = 10.0;
  late Widget chilr;
  OverlayEntry? _entry;
  late Offset _offset;
  late Rect _showRect;
  bool _isDown = true;
  VoidCallback? dismissCallback;
  PopupMenuStateChanged? stateChangd;
  late Size _screenSize;
  static late BuildContext buildContext;
  late Color _backgroundColor;
  bool _isShow = false;
  bool get isShow => _isShow;
  PopupDialog({
    required BuildContext context,
    required Widget child,
    VoidCallback? onDismiss,
    int maxColumn = 4,
    Color? backgroundColor,
    Color? highlightColor,
    Color? lineColor,
    PopupMenuStateChanged? stateChanged,
  }) {
    dismissCallback = onDismiss;
    stateChangd = stateChanged;
    chilr = child;
    _backgroundColor = backgroundColor ?? const Color(0xff232323);
    buildContext = context;
  }

  void show({Rect? rect, GlobalKey? widgetKey}) {
    if (rect == null && widgetKey == null) {
      debugPrint("'rect' and 'key' can't be both null");
      return;
    }

    _showRect = rect ?? PopupDialog.getWidgetGlobalRect(widgetKey!);
    _screenSize = window.physicalSize / window.devicePixelRatio;
    dismissCallback = dismissCallback;

    _calculatePosition(PopupDialog.buildContext);

    _entry = OverlayEntry(builder: (context) {
      return buildPopupMenuLayout(_offset);
    });

    Overlay.of(PopupDialog.buildContext)!.insert(_entry!);
    _isShow = true;
    if (stateChangd != null) {
      stateChangd!(true);
    }
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  void _calculatePosition(BuildContext context) {
    _offset = _calculateOffset(PopupDialog.buildContext);
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
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isDown = false;
    } else {
      dy -= arrowHeight;
      _isDown = true;
    }

    return Offset(dx, dy);
  }

  double menuWidth() {
    return min(MediaQuery.of(buildContext).size.width * 0.75, 400);
  }

  double menuHeight() {
    return MediaQuery.of(buildContext).size.height * 0.75;
  }

  LayoutBuilder buildPopupMenuLayout(Offset offset) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dismiss();
        },
        onVerticalDragStart: (DragStartDetails details) {
          dismiss();
        },
        onHorizontalDragStart: (DragStartDetails details) {
          dismiss();
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: _showRect.left + _showRect.width / 2.0 - 7.5,
              top: _isDown ? offset.dy + menuHeight() : offset.dy - arrowHeight,
              child: CustomPaint(
                size: Size(15.0, arrowHeight),
                painter: MyyPainter(isDown: _isDown, color: _backgroundColor),
              ),
            ),
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
                        /* width: menuWidth(),
                        height: menuHeight(), */
                        child: chilr,
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(10.0),
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

  double get screenWidth {
    double width = window.physicalSize.width;
    double ratio = window.devicePixelRatio;
    return width / ratio;
  }

  void dismiss() {
    if (!_isShow) {
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

class MyyPainter extends CustomPainter {
  bool isDown;
  Color color;

  MyyPainter({this.isDown = true, this.color = const Color.fromARGB(255, 0, 0, 0)});

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = Paint();
    _paint.strokeWidth = 2.0;
    _paint.color = color;
    _paint.style = PaintingStyle.fill;

    Path path = Path();
    if (isDown) {
      path.moveTo(0.0, -1.0);
      path.lineTo(size.width, -1.0);
      path.lineTo(size.width / 2.0, size.height);
    } else {
      path.moveTo(size.width / 2.0, 0.0);
      path.lineTo(0.0, size.height + 1);
      path.lineTo(size.width, size.height + 1);
      path.conicTo(size.width / 2.0, size.height, 56, 58, 10);
    }

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
