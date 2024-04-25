import 'package:flutter/material.dart';
import "dart:math" show pi;

class SliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.

   SliderThumbShape({
    required this.inColor,
    this.enabledThumbRadius = 5.0,
    this.disabledThumbRadius = 10.0,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the material default of 10 is used.
  final double enabledThumbRadius;
  var inColor;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double? disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  ///
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double>? activationAnimation,
        required Animation<double> enableAnimation,
        bool? isDiscrete,
        TextPainter? labelPainter,
        RenderBox? parentBox,
        required SliderThemeData sliderTheme,
        TextDirection? textDirection,
        double? value,
        double? textScaleFactor,
        Size? sizeWithOverflow,
      }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);
    assert(!sizeWithOverflow!.isEmpty);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );

    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation = elevationTween.evaluate(activationAnimation!);

    {
      final Path path = Path()
        ..addArc(Rect.fromCenter(center: center, width: 1 * radius, height: 1 * radius), 0, pi * 2);

      Paint paint = Paint()..color = Colors.white;
      paint.strokeWidth = 15;
      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(
        center,
        radius,
        paint,
      );
      {
        Paint paint = Paint()..color = Color(inColor);
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(
          center,
          4,
          paint,
        );
      }
    }
  }
}