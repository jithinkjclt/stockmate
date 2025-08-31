import 'package:flutter/material.dart';

class Screen {
  static Future<dynamic> open(
      BuildContext context,
      Widget target, {
        bool isAnimate = true,
        Offset? begin,
        Curve? curve,
      }) {
    return isAnimate
        ? Navigator.push(
      context,
      _createRoute(
        target,
        begin ?? const Offset(1, 0),
        curve ?? Curves.easeInOut,
      ),
    )
        : Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => target),
    );
  }

  static close(BuildContext context, {dynamic result}) =>
      Navigator.pop(context, result);

  static closeDialog(BuildContext context, {dynamic result}) =>
      Navigator.of(context, rootNavigator: true).pop(result);

  static closePopupOpenPage(
      BuildContext context,
      Widget target, {
        bool isAnimate = true,
        Offset? begin,
        Curve? curve,
      }) {
    closeDialog(context);
    isAnimate
        ? Navigator.pushReplacement(
      context,
      _createRoute(
        target,
        begin ?? const Offset(1, 0),
        curve ?? Curves.easeInOut,
      ),
    )
        : Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => target),
    );
  }

  static openClosingCurrentPage(
      BuildContext context,
      Widget target, {
        bool isAnimate = true,
        Offset? begin,
        Curve? curve,
      }) {
    return isAnimate
        ? Navigator.pushReplacement(
      context,
      _createRoute(
        target,
        begin ?? const Offset(1, 0),
        curve ?? Curves.easeInOut,
      ),
    )
        : Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => target),
    );
  }

  static openAsNewPage(
      BuildContext context,
      Widget target, {
        bool isAnimate = true,
        Offset? begin,
        Curve? curve,
      }) {
    return isAnimate
        ? Navigator.pushAndRemoveUntil(
      context,
      _createRoute(
        target,
        begin ?? const Offset(1, 0),
        curve ?? Curves.easeInOut,
      ),
          (route) => false,
    )
        : Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => target),
          (route) => false,
    );
  }

  static Route _createRoute(Widget target, Offset begin, Curve curve) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => target,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: begin, end: Offset.zero)
            .chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}
