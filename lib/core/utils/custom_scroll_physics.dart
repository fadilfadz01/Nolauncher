import 'package:flutter/material.dart';

class FastScrollPhysics extends ScrollPhysics {
  const FastScrollPhysics({super.parent});

  @override
  FastScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Increase swipe response sensitivity
    return super.applyPhysicsToUserOffset(position, offset * 1.5);
  }
}

class FastBouncingScrollPhysics extends BouncingScrollPhysics {
  const FastBouncingScrollPhysics({super.parent});

  @override
  FastBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Increase swipe response sensitivity
    return super.applyPhysicsToUserOffset(position, offset * 1.5);
  }
}
