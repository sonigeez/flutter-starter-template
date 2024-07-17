import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScalingButton extends StatefulWidget {
  const ScalingButton({
    super.key,
    required this.child,
    this.onTap,
    this.scaleFactor = 0.96,
    this.hapticMediumImpact = true,
    this.onLongPress,
    this.onLongPressEnd,
  });
  final double scaleFactor;

  final Widget child;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  // final VoidCallback? onLongPressEnd; void Function(dynamic)
  final Function(dynamic details)? onLongPressEnd;

  final bool hapticMediumImpact;

  @override
  ScalingButtonState createState() => ScalingButtonState();
}

class ScalingButtonState extends State<ScalingButton> {
  double _scale = 1.0;
  late double _scaleFactor;
  final Duration _animationDuration = const Duration(milliseconds: 80);

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = _scaleFactor;
      if (widget.hapticMediumImpact) {
        HapticFeedback.lightImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    });
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    Future.delayed(const Duration(milliseconds: 80), () {
      _scale = 1 - (_scaleFactor / 1) + 1;
      if (mounted) {
        setState(() {});
      }

      Future.delayed(const Duration(milliseconds: 80), () {
        _scale = 1.0;

        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  initState() {
    super.initState();
    _scaleFactor = widget.scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: () {
        widget.onTap?.call();
      },
      onLongPress: () {
        setState(() {
          _scale = _scaleFactor;
        });
        widget.onLongPress?.call();
      },
      onLongPressEnd: (details) {
        setState(() {
          _scale = 1.0;
        });
        widget.onLongPressEnd?.call(details);
      },
      onTapCancel: () {
        setState(() {
          _scale = 1.0;
        });
      },
      child: AnimatedScale(
        duration: _animationDuration,
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
