import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Tween<Offset> _kBottomUpTween = Tween<Offset>(
  begin: const Offset(0, 1),
  end: Offset.zero,
);

// Offset from offscreen to the right to fully on screen.
final Tween<Offset> _kRightMiddleTween = Tween<Offset>(
  begin: const Offset(1, 0),
  end: Offset.zero,
);

// Offset from offscreen below to fully on screen.
class AppPageRoute extends MaterialPageRoute<String> {
  AppPageRoute({
    required this.wbuilder,
    RouteSettings super.settings = const RouteSettings(),
    this.wmaintainState = true,
    super.fullscreenDialog,
  }) : super(builder: wbuilder) {
    assert(opaque, true);
  }

  final bool wmaintainState;

  final WidgetBuilder wbuilder;

  @override
  bool get maintainState => wmaintainState;
  @override
  WidgetBuilder get builder => wbuilder;

  @override
  Color? get barrierColor => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 2000);

  CupertinoPageRoute<String> get _cupertinoPageRoute {
    return CupertinoPageRoute<String>(
      builder: builder,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
    );
  }

  bool get _useCupertinoTransitions {
    // return _cupertinoPageRoute.popGestureInProgress == true ||
    //     Theme.of(navigator!.context).platform == TargetPlatform.iOS;
    return false;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final result = builder(context);
    return result;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (_useCupertinoTransitions) {
      return _cupertinoPageRoute.buildTransitions(
        context,
        animation,
        secondaryAnimation,
        child,
      );
    }

    return _CustomPageTransition(
      routeAnimation: animation,
      fullscreenDialog: fullscreenDialog,
      child: child,
    );
  }
}

class _CustomPageTransition extends StatelessWidget {
  _CustomPageTransition({
    required Animation<double> routeAnimation,
    required this.child,
    required this.fullscreenDialog,
  }) : _positionAnimation = !fullscreenDialog
            ? _kRightMiddleTween.animate(
                CurvedAnimation(
                  parent: routeAnimation,
                  curve: Curves.elasticIn,
                ),
              )
            : _kBottomUpTween.animate(
                CurvedAnimation(
                  parent:
                      routeAnimation, // The route's linear 0.0 - 1.0 animation.
                  curve: Curves.elasticIn,
                ),
              );
  final Animation<Offset> _positionAnimation;

  final Widget child;
  final bool fullscreenDialog;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _positionAnimation,
      child: child,
    );
  }
}
