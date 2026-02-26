import 'package:flutter/rendering.dart';

/// A custom painter that draws a triangle, typically used as an arrow
/// pointing to the target widget of a popup menu.
class TrianglePainter extends CustomPainter {
  /// Whether the triangle points downwards.
  /// If false, the triangle points upwards.
  bool isDown;

  /// The fill color of the triangle.
  Color color;

  /// Creates a [TrianglePainter].
  TrianglePainter({this.isDown = true, this.color = const Color.fromARGB(0, 0, 0, 0)});

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
    }

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
