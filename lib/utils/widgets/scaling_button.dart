import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class ScalingButton extends StatefulWidget {
  const ScalingButton({
    required this.child,
    super.key,
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

  final void Function(dynamic details)? onLongPressEnd;

  final bool hapticMediumImpact;

  @override
  ScalingButtonState createState() => ScalingButtonState();
}

class ScalingButtonState extends State<ScalingButton> {
  double _scale = 1;
  late double _scaleFactor;
  final Duration _animationDuration = 80.ms;

  Future<void> _onTapDown(TapDownDetails details) async {
    if (widget.onTap == null) return;

    setState(() {
      _scale = _scaleFactor;
    });
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    if (widget.onTap == null) return;
    Future.delayed(40.ms, () {
      _scale = 1 - (_scaleFactor / 1) + 1;
      if (mounted) {
        setState(() {});
      }

      Future.delayed(40.ms, () {
        _scale = 1.0;
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _scaleFactor = widget.scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: () {
        if (widget.onTap == null) return;
        widget.onTap?.call();
        Haptics.vibrate(HapticsType.soft);
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
