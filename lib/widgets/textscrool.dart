import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class AutoScrollText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextScrollMode mode;
  final int intervalSpaces;
  final Velocity velocity;
  final Duration delayBefore;
  final Duration pauseBetween;

  const AutoScrollText({
    super.key,
    required this.text,
    required this.style,
    this.mode = TextScrollMode.endless,
    this.intervalSpaces = 7,
    this.velocity = const Velocity(pixelsPerSecond: Offset(30, 0)),
    this.delayBefore = const Duration(seconds: 1),
    this.pauseBetween = const Duration(seconds: 2),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tp = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: Directionality.of(context),
        )..layout();

        final fits = tp.size.width <= constraints.maxWidth;

        if (fits) {
          return SizedBox(
            width: double.infinity,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }

        return SizedBox(
          width: double.infinity,
          child: TextScroll(
            text,
            mode: mode,
            intervalSpaces: intervalSpaces,
            velocity: velocity,
            delayBefore: delayBefore,
            pauseBetween: pauseBetween,
            style: style,
            textAlign: TextAlign.left,
          ),
        );
      },
    );
  }
}
