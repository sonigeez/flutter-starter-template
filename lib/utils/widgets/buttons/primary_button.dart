import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:patrika_community_app/utils/widgets/scaling_button.dart';

// variant
enum ButtonVariant { primary, secondary, disabled }

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    required this.child, super.key,
    this.onTap,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
  });

  final VoidCallback? onTap;
  final Widget child;
  final ButtonVariant variant;
  final bool isLoading;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ScalingButton(
      onTap: (widget.variant == ButtonVariant.disabled || widget.isLoading)
          ? null
          : widget.onTap,
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: _getButtonColor(context),
          borderRadius: BorderRadius.circular(48),
          border: Border.all(
            color: _getBorderColor(),
          ),
          boxShadow:
              widget.variant == ButtonVariant.primary && !widget.isLoading
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLoading)
              SizedBox(
                width: 23,
                height: 23,
                child: LoadingSpinner(
                  strokeWidth: 1.5,
                  valueColor: _getLoadingColor(context),
                ),
              )
            else
              widget.child,
          ],
        ),
      ),
    );
  }

  Color _getButtonColor(BuildContext context) {
    if (widget.isLoading || widget.variant == ButtonVariant.disabled) {
      return Theme.of(context).disabledColor;
    }
    switch (widget.variant) {
      case ButtonVariant.primary:
        return Theme.of(context).primaryColor;
      case ButtonVariant.secondary:
        return Colors.white;
      case ButtonVariant.disabled:
        return Theme.of(context).disabledColor;
    }
  }

  Color _getBorderColor() {
    if (widget.isLoading || widget.variant == ButtonVariant.disabled) {
      return Colors.grey;
    }
    switch (widget.variant) {
      case ButtonVariant.primary:
        return Colors.black;
      case ButtonVariant.secondary:
        return Colors.black;
      case ButtonVariant.disabled:
        return Colors.grey;
    }
  }

  Color _getLoadingColor(BuildContext context) {
    return Colors.white;
  }
}

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({
    required this.strokeWidth, required this.valueColor, super.key,
  });
  final double strokeWidth;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;
    return isIos
        ? CupertinoActivityIndicator(
            color: valueColor,
          )
        : CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(valueColor),
          );
  }
}
