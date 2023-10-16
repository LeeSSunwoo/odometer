import 'package:flutter/material.dart';
import 'package:odometer/src/odometer_animation.dart';
import 'package:odometer/src/odometer_number.dart';

/// The [ImplicitlyAnimatedWidget] uses the [AnimatedOdometer]
/// with the sliding and fading digits transitions.
class AnimatedSlideOdometerNumber extends StatelessWidget {
  final OdometerNumber odometerNumber;
  final Duration duration;

  /// The width of the SizedBox widget around each digit avoids the movement
  /// of the digits when they change.
  final double letterWidth;

  /// A widget that is used to separate digit groups.
  ///
  /// For example, if you pass the Text(',') as the separator,
  /// the 10000 value result will be rendered as '10,000'.
  final Widget? groupSeparator;

  /// The digit's [TextStyle].
  final TextStyle? numberTextStyle;

  /// The vertical offset is used to translate digits.
  final double verticalOffset;

  /// The curve animates the odometer number.
  final Curve curve;

  const AnimatedSlideOdometerNumber({
    Key? key,
    required this.odometerNumber,
    required this.duration,
    this.numberTextStyle,
    this.curve = Curves.linear,
    required this.letterWidth,
    this.verticalOffset = 20,
    this.groupSeparator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOdometer(
      curve: curve,
      odometerNumber: odometerNumber,
      transitionIn: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        odometerNumber.number,
        animation,
        verticalOffset * animation - verticalOffset,
        groupSeparator,
        numberTextStyle,
        letterWidth,
      ),
      transitionOut: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        odometerNumber.number,
        1 - animation,
        verticalOffset * animation,
        groupSeparator,
        numberTextStyle,
        letterWidth,
      ),
      duration: duration,
    );
  }
}

/// The ExplicitlyAnimatedWidget uses the [OdometerTransition]
/// with the sliding and fading digits transitions.
class SlideOdometerTransition extends StatelessWidget {
  final Animation<OdometerNumber> odometerAnimation;

  /// The width of the SizedBox widget around each digit avoids the movement
  /// of the digits when they change.
  final double letterWidth;

  /// A widget that is used to separate digit groups.
  ///
  /// For example, if you pass the Text(',') as the separator,
  /// the 10000 value result will be rendered as '10,000'.
  final Widget? groupSeparator;

  /// The digit's [TextStyle].
  final TextStyle? numberTextStyle;

  /// The vertical offset is used to translate digits.
  final double verticalOffset;

  const SlideOdometerTransition({
    Key? key,
    required this.odometerAnimation,
    this.numberTextStyle,
    required this.letterWidth,
    this.verticalOffset = 20,
    this.groupSeparator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OdometerTransition(
      odometerAnimation: odometerAnimation,
      transitionIn: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        0,
        animation,
        verticalOffset * animation - verticalOffset,
        groupSeparator,
        numberTextStyle,
        letterWidth,
      ),
      transitionOut: (value, place, animation) => _buildSlideOdometerDigit(
        value,
        place,
        0,
        1 - animation,
        verticalOffset * animation,
        groupSeparator,
        numberTextStyle,
        letterWidth,
      ),
    );
  }
}

Widget _buildSlideOdometerDigit(
  int value,
  int place,
  int length,
  double opacity,
  double offsetY,
  Widget? groupSeparator,
  TextStyle? numberTextStyle,
  double letterWidth,
) {
  final d = place - 1;
  if (groupSeparator != null && (d != 0 && d % 3 == 0)) {
    return Row(
      children: [
        _valueText(value, place, length, opacity, offsetY, numberTextStyle, letterWidth),
        groupSeparator,
      ],
    );
  } else {
    return _valueText(value, place, length, opacity, offsetY, numberTextStyle, letterWidth);
  }
}

Widget _valueText(
  int value,
  int place,
  int length,
  double opacity,
  double offsetY,
  TextStyle? numberTextStyle,
  double letterWidth,
) =>
    Transform.translate(
      offset: Offset(0, offsetY),
      child: Opacity(
        opacity: length == 0 ? opacity : (place > length.toString().length && value == 0) ? 0 : opacity,
        child: SizedBox(
          width: letterWidth,
          child: Text(
            value.toString(),
            style: numberTextStyle,
          ),
        ),
      ),
    );
