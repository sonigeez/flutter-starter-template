import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/services.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// direction that icon should place to the text
enum IconPosition { left, right, top, bottom }

/// wrap child in outside,mostly use in add background color and padding
typedef OuterBuilder = Widget Function(Widget child);

///the most common indicator,combine with a text and a icon
///
/// See also:
///
/// [ClassicFooter]
class CustomRefreshHeader extends RefreshIndicator {
  const CustomRefreshHeader({
    super.key,
    RefreshStyle super.refreshStyle,
    super.height,
    super.completeDuration = const Duration(milliseconds: 600),
    this.outerBuilder,
    this.textStyle = const TextStyle(color: Colors.grey),
    this.releaseText,
    this.refreshingText,
    this.canTwoLevelIcon,
    this.twoLevelView,
    this.canTwoLevelText,
    this.completeText,
    this.failedText,
    this.idleText,
    this.iconPos = IconPosition.left,
    this.spacing = 15.0,
    this.refreshingIcon,
    this.failedIcon = const Icon(Icons.error, color: Colors.grey),
    this.completeIcon = const Icon(Icons.done, color: Colors.grey),
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
    this.releaseIcon = const Icon(Icons.refresh, color: Colors.grey),
  });

  /// a builder for re wrap child,If you need to change the boxExtent or background,padding etc.you need outerBuilder to reWrap child
  /// example:
  /// ```dart
  /// outerBuilder:(child){
  ///    return Container(
  ///       color:Colors.red,
  ///       child:child
  ///    );
  /// }
  /// ````
  /// In this example,it will help to add backgroundColor in indicator
  final OuterBuilder? outerBuilder;
  final String? releaseText;
  final String? idleText;
  final String? refreshingText;
  final String? completeText;
  final String? failedText;
  final String? canTwoLevelText;
  final Widget? releaseIcon;
  final Widget? idleIcon;
  final Widget? refreshingIcon;
  final Widget? completeIcon;
  final Widget? failedIcon;
  final Widget? canTwoLevelIcon;
  final Widget? twoLevelView;

  /// icon and text middle margin
  final double spacing;
  final IconPosition iconPos;

  final TextStyle textStyle;

  @override
  State createState() {
    return _SpilllRefreshHeaderState();
  }
}

class _SpilllRefreshHeaderState
    extends RefreshIndicatorState<CustomRefreshHeader> {
  // Widget _buildText(mode) {
  //   RefreshString strings =
  //       RefreshLocalizations.of(context)?.currentLocalization ??
  //           EnRefreshString();

  //   String textToShow = mode == RefreshStatus.canRefresh
  //       ? widget.releaseText ?? strings.canRefreshText!
  //       : mode == RefreshStatus.completed
  //           ? widget.completeText ?? strings.refreshCompleteText!
  //           : mode == RefreshStatus.failed
  //               ? widget.failedText ?? strings.refreshFailedText!
  //               : mode == RefreshStatus.refreshing
  //                   ? widget.refreshingText ?? strings.refreshingText!
  //                   : mode == RefreshStatus.idle
  //                       ? widget.idleText ?? strings.idleRefreshText!
  //                       : mode == RefreshStatus.canTwoLevel
  //                           ? widget.canTwoLevelText ?? strings.canTwoLevelText!
  //                           : "";

  //   return AnimatedSwitcher(
  //     duration: const Duration(milliseconds: 120), // Customize duration here
  //     child: Text(
  //       textToShow,
  //       key: ValueKey<String>(textToShow),
  //       style: widget.textStyle,
  //     ),
  //   );
  // }

  Widget _buildIcon(RefreshStatus mode) {
    if (mode == RefreshStatus.refreshing) {
      HapticFeedback.lightImpact();
    }
    final icon = mode == RefreshStatus.canRefresh
        ? widget.releaseIcon
        : mode == RefreshStatus.idle
            ? widget.idleIcon
            : mode == RefreshStatus.completed
                ? widget.completeIcon
                : mode == RefreshStatus.failed
                    ? widget.failedIcon
                    : mode == RefreshStatus.canTwoLevel
                        ? widget.canTwoLevelIcon
                        : mode == RefreshStatus.refreshing
                            ? widget.refreshingIcon ??
                                SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                      ? const CupertinoActivityIndicator()
                                      : const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                )
                            : widget.twoLevelView;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => RotationTransition(
        turns: child.key == ValueKey(mode == RefreshStatus.refreshing)
            ? Tween<double>(begin: 1, end: 0.8).animate(anim)
            : Tween<double>(begin: 0.8, end: 1).animate(anim),
        child: ScaleTransition(
          scale: anim,
          child: child,
        ),
      ),
      child: SizedBox(
        key: ValueKey(mode.toString()),
        child: icon ?? Container(),
      ), // Fallback to an empty container if no icon is available
    );
  }

  @override
  bool needReverseAll() {
    return false;
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    // Widget textWidget = _buildText(mode);
    final iconWidget = _buildIcon(mode ?? RefreshStatus.idle);
    final children = <Widget>[iconWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left
          ? TextDirection.ltr
          : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom ||
              widget.iconPos == IconPosition.top
          ? Axis.vertical
          : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom
          ? VerticalDirection.up
          : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder!(container)
        : SizedBox(
            height: widget.height,
            child: Center(child: container),
          );
  }
}

///the most common indicator,combine with a text and a icon
///
// See also:
//
// [SpilllRefreshHeader]
class ClassicFooter extends LoadIndicator {
  const ClassicFooter({
    super.key,
    super.onClick,
    super.loadStyle,
    super.height,
    this.outerBuilder,
    this.textStyle = const TextStyle(color: Colors.grey),
    this.loadingText,
    this.noDataText,
    this.noMoreIcon,
    this.idleText,
    this.failedText,
    this.canLoadingText,
    this.failedIcon = const Icon(Icons.error, color: Colors.grey),
    this.iconPos = IconPosition.left,
    this.spacing = 15.0,
    this.completeDuration = const Duration(milliseconds: 300),
    this.loadingIcon,
    this.canLoadingIcon = const Icon(Icons.autorenew, color: Colors.grey),
    this.idleIcon = const Icon(Icons.arrow_upward, color: Colors.grey),
  });
  final String? idleText;
  final String? loadingText;
  final String? noDataText;
  final String? failedText;
  final String? canLoadingText;

  /// a builder for re wrap child,If you need to change the boxExtent or background,padding etc.you need outerBuilder to reWrap child
  /// example:
  /// ```dart
  /// outerBuilder:(child){
  ///    return Container(
  ///       color:Colors.red,
  ///       child:child
  ///    );
  /// }
  /// ````
  /// In this example,it will help to add backgroundColor in indicator
  final OuterBuilder? outerBuilder;

  final Widget? idleIcon;
  final Widget? loadingIcon;
  final Widget? noMoreIcon;
  final Widget? failedIcon;
  final Widget? canLoadingIcon;

  /// icon and text middle margin
  final double spacing;

  final IconPosition iconPos;

  final TextStyle textStyle;

  /// notice that ,this attrs only works for LoadStyle.ShowWhenLoading
  final Duration completeDuration;

  @override
  State<StatefulWidget> createState() {
    //

    return _ClassicFooterState();
  }
}

class _ClassicFooterState extends LoadIndicatorState<ClassicFooter> {
  Widget _buildText(LoadStatus? mode) {
    final strings = RefreshLocalizations.of(context)?.currentLocalization ??
        EnRefreshString();
    return Text(
      mode == LoadStatus.loading
          ? widget.loadingText ?? strings.loadingText!
          : LoadStatus.noMore == mode
              ? widget.noDataText ?? strings.noMoreText!
              : LoadStatus.failed == mode
                  ? widget.failedText ?? strings.loadFailedText!
                  : LoadStatus.canLoading == mode
                      ? widget.canLoadingText ?? strings.canLoadingText!
                      : widget.idleText ?? strings.idleLoadingText!,
      // style: widget.textStyle,
    );
  }

  Widget _buildIcon(LoadStatus? mode) {
    final icon = mode == LoadStatus.loading
        ? widget.loadingIcon ??
            SizedBox(
              width: 25,
              height: 25,
              child: defaultTargetPlatform == TargetPlatform.iOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(strokeWidth: 2),
            )
        : mode == LoadStatus.noMore
            ? widget.noMoreIcon
            : mode == LoadStatus.failed
                ? widget.failedIcon
                : mode == LoadStatus.canLoading
                    ? widget.canLoadingIcon
                    : widget.idleIcon;
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 30,
      ), // Adjust animation duration as needed
      child: icon ??
          Container(), // Fallback to an empty container if no icon is available
    );
  }

  @override
  Future<void> endLoading() {
    return Future.delayed(widget.completeDuration);
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus? mode) {
    final textWidget = _buildText(mode);
    final iconWidget = _buildIcon(mode);
    final children = <Widget>[iconWidget, textWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left
          ? TextDirection.ltr
          : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom ||
              widget.iconPos == IconPosition.top
          ? Axis.vertical
          : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom
          ? VerticalDirection.up
          : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder!(container)
        : SizedBox(
            height: widget.height,
            child: Center(
              child: container,
            ),
          );
  }
}
