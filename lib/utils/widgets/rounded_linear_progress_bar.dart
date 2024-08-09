import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double _kMinCircularProgressIndicatorSize = 36;
const int _kIndeterminateLinearDuration = 1800;
const int _kIndeterminateCircularDuration = 1333 * 2222;

enum _ActivityIndicatorType { material, adaptive }

abstract class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final double? value;

  final Color? backgroundColor;

  final Color? color;

  final Animation<Color?>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;

  Color _getValueColor(BuildContext context, {Color? defaultColor}) {
    return valueColor?.value ??
        color ??
        ProgressIndicatorTheme.of(context).color ??
        defaultColor ??
        Theme.of(context).colorScheme.primary;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      PercentProperty(
        'value',
        value,
        showName: false,
        ifNull: '<indeterminate>',
      ),
    );
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    var expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }
}

class _RoundedLinearProgressIndicatorPainter extends CustomPainter {
  const _RoundedLinearProgressIndicatorPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.animationValue,
    required this.textDirection,
    required this.indicatorBorderRadius,
    this.value,
  });

  final Color backgroundColor;
  final Color valueColor;
  final double? value;
  final double animationValue;
  final TextDirection textDirection;
  final BorderRadiusGeometry indicatorBorderRadius;

  static const Curve line1Head = Interval(
    0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0, 0.8, 1),
  );
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0, 1, 1),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0, 0, 0.65, 1),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0, 0.45, 1),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    void drawBar(double x, double width) {
      if (width <= 0.0) {
        return;
      }

      final double left;
      switch (textDirection) {
        case TextDirection.rtl:
          left = size.width - width - x;
        case TextDirection.ltr:
          left = x;
      }

      final rect = Offset(left, 0) & Size(width, size.height);
      if (indicatorBorderRadius != BorderRadius.zero) {
        final rrect =
            indicatorBorderRadius.resolve(textDirection).toRRect(rect);
        canvas.drawRRect(rrect, paint);
      } else {
        canvas.drawRect(rect, paint);
      }
    }

    if (value != null) {
      drawBar(0, clampDouble(value!, 0, 1) * size.width);
    } else {
      final x1 = size.width * line1Tail.transform(animationValue);
      final width1 = size.width * line1Head.transform(animationValue) - x1;

      final x2 = size.width * line2Tail.transform(animationValue);
      final width2 = size.width * line2Head.transform(animationValue) - x2;

      drawBar(x1, width1);
      drawBar(x2, width2);
    }
  }

  @override
  bool shouldRepaint(_RoundedLinearProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.animationValue != animationValue ||
        oldPainter.textDirection != textDirection ||
        oldPainter.indicatorBorderRadius != indicatorBorderRadius;
  }
}

class RoundedLinearProgressIndicator extends ProgressIndicator {
  const RoundedLinearProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.minHeight,
    super.semanticsLabel,
    super.semanticsValue,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : assert(
          minHeight == null || minHeight > 0,
          'The minHeight must be greater than 0.',
        );

  final double? minHeight;
  final BorderRadiusGeometry borderRadius;

  @override
  State<RoundedLinearProgressIndicator> createState() =>
      _RoundedLinearProgressIndicatorState();
}

class _RoundedLinearProgressIndicatorState
    extends State<RoundedLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(RoundedLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(
    BuildContext context,
    double animationValue,
    TextDirection textDirection,
  ) {
    final defaults = Theme.of(context).useMaterial3
        ? _RoundedLinearProgressIndicatorDefaultsM3(context)
        : _RoundedLinearProgressIndicatorDefaultsM2(context);

    final indicatorTheme = ProgressIndicatorTheme.of(context);
    final trackColor = widget.backgroundColor ??
        indicatorTheme.linearTrackColor ??
        defaults.linearTrackColor!;
    final minHeight = widget.minHeight ??
        indicatorTheme.linearMinHeight ??
        defaults.linearMinHeight!;

    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        clipBehavior:
            (widget.borderRadius != BorderRadius.zero && widget.value == null)
                ? Clip.antiAlias
                : Clip.none,
        decoration: ShapeDecoration(
          color: trackColor,
          shape: RoundedRectangleBorder(borderRadius: widget.borderRadius),
        ),
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: minHeight,
        ),
        child: CustomPaint(
          painter: _RoundedLinearProgressIndicatorPainter(
            backgroundColor: trackColor,
            valueColor:
                widget._getValueColor(context, defaultColor: defaults.color),
            value: widget.value, // may be null
            animationValue:
                animationValue, // ignored if widget.value is not null
            textDirection: textDirection,
            indicatorBorderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);

    if (widget.value != null) {
      return _buildIndicator(context, _controller.value, textDirection);
    }

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(context, _controller.value, textDirection);
      },
    );
  }
}

class _CircularProgressIndicatorPainter extends CustomPainter {
  _CircularProgressIndicatorPainter({
    required this.valueColor,
    required this.value,
    required this.headValue,
    required this.tailValue,
    required this.offsetValue,
    required this.rotationValue,
    required this.strokeWidth,
    required this.strokeAlign,
    this.backgroundColor,
    this.strokeCap,
  })  : arcStart = value != null
            ? _startAngle
            : _startAngle +
                tailValue * 3 / 2 * math.pi +
                rotationValue * math.pi * 2.0 +
                offsetValue * 0.5 * math.pi,
        arcSweep = value != null
            ? clampDouble(value, 0, 1) * _sweep
            : math.max(
                headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi,
                _epsilon,
              );

  final Color? backgroundColor;
  final Color valueColor;
  final double? value;
  final double headValue;
  final double tailValue;
  final double offsetValue;
  final double rotationValue;
  final double strokeWidth;
  final double strokeAlign;
  final double arcStart;
  final double arcSweep;
  final StrokeCap? strokeCap;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final strokeOffset = strokeWidth / 2 * -strokeAlign;
    final arcBaseOffset = Offset(strokeOffset, strokeOffset);
    final arcActualSize = Size(
      size.width - strokeOffset * 2,
      size.height - strokeOffset * 2,
    );

    if (backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = backgroundColor!
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        arcBaseOffset & arcActualSize,
        0,
        _sweep,
        false,
        backgroundPaint,
      );
    }

    paint.strokeCap = strokeCap ?? StrokeCap.round;

    canvas.drawArc(
      arcBaseOffset & arcActualSize,
      arcStart,
      arcSweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.headValue != headValue ||
        oldPainter.tailValue != tailValue ||
        oldPainter.offsetValue != offsetValue ||
        oldPainter.rotationValue != rotationValue ||
        oldPainter.strokeWidth != strokeWidth ||
        oldPainter.strokeAlign != strokeAlign ||
        oldPainter.strokeCap != strokeCap;
  }
}

class CircularProgressIndicator extends ProgressIndicator {
  const CircularProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.strokeWidth = 4.0,
    this.strokeAlign = strokeAlignCenter,
    super.semanticsLabel,
    super.semanticsValue,
    this.strokeCap = StrokeCap.round,
  }) : _indicatorType = _ActivityIndicatorType.material;

  const CircularProgressIndicator.adaptive({
    super.key,
    super.value,
    super.backgroundColor,
    super.valueColor,
    this.strokeWidth = 4.0,
    super.semanticsLabel,
    super.semanticsValue,
    this.strokeCap = StrokeCap.round,
    this.strokeAlign = strokeAlignCenter,
  }) : _indicatorType = _ActivityIndicatorType.adaptive;

  final _ActivityIndicatorType _indicatorType;

  final double strokeWidth;
  final double strokeAlign;

  final StrokeCap? strokeCap;
  static const double strokeAlignInside = -1;

  static const double strokeAlignCenter = 0;

  static const double strokeAlignOutside = 1;

  @override
  State<CircularProgressIndicator> createState() =>
      _CircularProgressIndicatorState();
}

class _CircularProgressIndicatorState extends State<CircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  static const int _pathCount = _kIndeterminateCircularDuration ~/ 1333;
  static const int _rotationCount = _kIndeterminateCircularDuration ~/ 2222;

  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn),
  ).chain(
    CurveTween(
      curve: const SawTooth(_pathCount),
    ),
  );
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1, curve: Curves.fastOutSlowIn),
  ).chain(
    CurveTween(
      curve: const SawTooth(_pathCount),
    ),
  );
  static final Animatable<double> _offsetTween =
      CurveTween(curve: const SawTooth(_pathCount));
  static final Animatable<double> _rotationTween =
      CurveTween(curve: const SawTooth(_rotationCount));

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateCircularDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(CircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCupertinoIndicator(BuildContext context) {
    final tickColor = widget.backgroundColor;
    return CupertinoActivityIndicator(key: widget.key, color: tickColor);
  }

  Widget _buildMaterialIndicator(
    BuildContext context,
    double headValue,
    double tailValue,
    double offsetValue,
    double rotationValue,
  ) {
    final defaults = Theme.of(context).useMaterial3
        ? _CircularProgressIndicatorDefaultsM3(context)
        : _CircularProgressIndicatorDefaultsM2(context);
    final trackColor = widget.backgroundColor ??
        ProgressIndicatorTheme.of(context).circularTrackColor;

    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: _kMinCircularProgressIndicatorSize,
          minHeight: _kMinCircularProgressIndicatorSize,
        ),
        child: CustomPaint(
          painter: _CircularProgressIndicatorPainter(
            backgroundColor: trackColor,
            valueColor:
                widget._getValueColor(context, defaultColor: defaults.color),
            value: widget.value,
            headValue: headValue,
            tailValue: tailValue,
            offsetValue: offsetValue,
            rotationValue: rotationValue,
            strokeWidth: widget.strokeWidth,
            strokeAlign: widget.strokeAlign,
            strokeCap: widget.strokeCap,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return _buildMaterialIndicator(
          context,
          _strokeHeadTween.evaluate(_controller),
          _strokeTailTween.evaluate(_controller),
          _offsetTween.evaluate(_controller),
          _rotationTween.evaluate(_controller),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget._indicatorType) {
      case _ActivityIndicatorType.material:
        if (widget.value != null) {
          return _buildMaterialIndicator(context, 0, 0, 0, 0);
        }
        return _buildAnimation();
      case _ActivityIndicatorType.adaptive:
        final theme = Theme.of(context);
        switch (theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return _buildCupertinoIndicator(context);
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            if (widget.value != null) {
              return _buildMaterialIndicator(context, 0, 0, 0, 0);
            }
            return _buildAnimation();
        }
    }
  }
}

class _RefreshProgressIndicatorPainter
    extends _CircularProgressIndicatorPainter {
  _RefreshProgressIndicatorPainter({
    required super.valueColor,
    required super.value,
    required super.headValue,
    required super.tailValue,
    required super.offsetValue,
    required super.rotationValue,
    required super.strokeWidth,
    required super.strokeAlign,
    required this.arrowheadScale,
    required super.strokeCap,
  });

  final double arrowheadScale;

  void paintArrowhead(Canvas canvas, Size size) {
    final arcEnd = arcStart + arcSweep;
    final ux = math.cos(arcEnd);
    final uy = math.sin(arcEnd);

    assert(
      size.width == size.height,
      'The width and height of the size must be equal for a circular progress indicator.',
    );
    final radius = size.width / 2.0;
    final arrowheadPointX =
        radius + ux * radius + -uy * strokeWidth * 2.0 * arrowheadScale;
    final arrowheadPointY =
        radius + uy * radius + ux * strokeWidth * 2.0 * arrowheadScale;
    final arrowheadRadius = strokeWidth * 2.0 * arrowheadScale;
    final innerRadius = radius - arrowheadRadius;
    final outerRadius = radius + arrowheadRadius;

    final path = Path()
      ..moveTo(radius + ux * innerRadius, radius + uy * innerRadius)
      ..lineTo(radius + ux * outerRadius, radius + uy * outerRadius)
      ..lineTo(arrowheadPointX, arrowheadPointY)
      ..close();

    final paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (arrowheadScale > 0.0) {
      paintArrowhead(canvas, size);
    }
  }
}

class RefreshProgressIndicator extends CircularProgressIndicator {
  const RefreshProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    super.strokeWidth = defaultStrokeWidth,
    super.strokeAlign,
    super.semanticsLabel,
    super.semanticsValue,
    super.strokeCap,
    this.elevation = 2.0,
    this.indicatorMargin = const EdgeInsets.all(4),
    this.indicatorPadding = const EdgeInsets.all(12),
  });

  final double elevation;

  final EdgeInsetsGeometry indicatorMargin;
  final EdgeInsetsGeometry indicatorPadding;
  static const double defaultStrokeWidth = 2.5;

  @override
  State<CircularProgressIndicator> createState() =>
      _RefreshProgressIndicatorState();
}

class _RefreshProgressIndicatorState extends _CircularProgressIndicatorState {
  static const double _indicatorSize = 41;

  /// Interval for arrow head to fully grow.
  static const double _strokeHeadInterval = 0.33;

  late final Animatable<double> _convertTween = CurveTween(
    curve: const Interval(0.1, _strokeHeadInterval),
  );

  late final Animatable<double> _additionalRotationTween =
      TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -0.1, end: -0.2),
        weight: _strokeHeadInterval,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -0.2, end: 1.35),
        weight: 1 - _strokeHeadInterval,
      ),
    ],
  );

  double? _lastValue;

  @override
  RefreshProgressIndicator get widget =>
      super.widget as RefreshProgressIndicator;
  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    if (value != null) {
      _lastValue = value;
      _controller.value = _convertTween.transform(value) *
          (1333 / 2 / _kIndeterminateCircularDuration);
    }
    return _buildAnimation();
  }

  @override
  Widget _buildAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return _buildMaterialIndicator(
          context,
          // Lengthen the arc a little
          1.05 *
              _CircularProgressIndicatorState._strokeHeadTween
                  .evaluate(_controller),
          _CircularProgressIndicatorState._strokeTailTween
              .evaluate(_controller),
          _CircularProgressIndicatorState._offsetTween.evaluate(_controller),
          _CircularProgressIndicatorState._rotationTween.evaluate(_controller),
        );
      },
    );
  }

  @override
  Widget _buildMaterialIndicator(
    BuildContext context,
    double headValue,
    double tailValue,
    double offsetValue,
    double rotationValue,
  ) {
    final value = widget.value;
    final arrowheadScale = value == null
        ? 0.0
        : const Interval(0.1, _strokeHeadInterval).transform(value);
    final double rotation;

    if (value == null && _lastValue == null) {
      rotation = 0.0;
    } else {
      rotation =
          math.pi * _additionalRotationTween.transform(value ?? _lastValue!);
    }

    var valueColor = widget._getValueColor(context);
    final opacity = valueColor.opacity;
    valueColor = valueColor.withOpacity(1);

    final backgroundColor = widget.backgroundColor ??
        ProgressIndicatorTheme.of(context).refreshBackgroundColor ??
        Theme.of(context).canvasColor;

    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        width: _indicatorSize,
        height: _indicatorSize,
        margin: widget.indicatorMargin,
        child: Material(
          type: MaterialType.circle,
          color: backgroundColor,
          elevation: widget.elevation,
          child: Padding(
            padding: widget.indicatorPadding,
            child: Opacity(
              opacity: opacity,
              child: Transform.rotate(
                angle: rotation,
                child: CustomPaint(
                  painter: _RefreshProgressIndicatorPainter(
                    valueColor: valueColor,
                    value: null,
                    headValue: headValue,
                    tailValue: tailValue,
                    offsetValue: offsetValue,
                    rotationValue: rotationValue,
                    strokeWidth: widget.strokeWidth,
                    strokeAlign: widget.strokeAlign,
                    arrowheadScale: arrowheadScale,
                    strokeCap: widget.strokeCap,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularProgressIndicatorDefaultsM2 extends ProgressIndicatorThemeData {
  _CircularProgressIndicatorDefaultsM2(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;
}

class _RoundedLinearProgressIndicatorDefaultsM2
    extends ProgressIndicatorThemeData {
  _RoundedLinearProgressIndicatorDefaultsM2(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.background;

  @override
  double get linearMinHeight => 4;
}

class _CircularProgressIndicatorDefaultsM3 extends ProgressIndicatorThemeData {
  _CircularProgressIndicatorDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;
}

class _RoundedLinearProgressIndicatorDefaultsM3
    extends ProgressIndicatorThemeData {
  _RoundedLinearProgressIndicatorDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.surfaceVariant;

  @override
  double get linearMinHeight => 4;
}
