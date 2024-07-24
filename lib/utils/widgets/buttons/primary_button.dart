import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:patrika_community_app/utils/widgets/scaling_button.dart';

// variant
enum ButtonVariant { primary, secondary, disabled }

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    this.onTap,
    required this.child,
    this.variant = ButtonVariant.primary,
  });

  final VoidCallback? onTap;
  final Widget child;
  final ButtonVariant variant;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ScalingButton(
      onTap: widget.variant == ButtonVariant.disabled ? null : widget.onTap,
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: _getButtonColor(context),
          // color: widget.variant == ButtonVariant.disabled
          //     ? Theme.of(context).disabledColor
          //     : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(48),
          border: Border.all(
            color: _getBorderColor(),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.child,
          ],
        ),
      ),
    );
  }

  _getButtonColor(BuildContext context) {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return Theme.of(context).primaryColor;
      case ButtonVariant.secondary:
        return Colors.white;
      case ButtonVariant.disabled:
        return Theme.of(context).disabledColor;
    }
  }

  _getBorderColor() {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return Colors.black;
      case ButtonVariant.secondary:
        return Colors.black;
      case ButtonVariant.disabled:
        return Colors.grey;
    }
  }
}
