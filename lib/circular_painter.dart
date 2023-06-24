// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

const TRANSPARENT_BLACK = Color.fromRGBO(0, 0, 0, 0.2);
const DEGREE_IN_RAD = 0.0174533;
const OVERALL = "Overall";
const gradientFiller = 400;
const TextFontSize = 18;

class ViewStyle {
  static int DOMINANT_WHITE = 0;
  static int DOMINANT_PURPLE = 1;
  static int DOMINANT_BLUE = 2;
}

class DrawFlowerPainter extends CustomPainter {
  final BuildContext context;
  final double overallPct;
  final bool shouldDraw;
  final int numSubjects;
  final double petalInnerRadius;
  final double petalOuterRadius;
  final List<double> subjectPercentages;
  final List<Color> startColors;
  final List<Color> endColors;
  final List<String> subjects;
  final List<double> scaleFactors;
  final double rotateAngle;
  final double initialRotateOffset;
  final double animationDuration;
  final double canvasCx;
  final double canvasCy;
  final Rect centerCircleRectF;
  final double animationStart;
  double legendColor = 0;
  double subjectTextColor = 0;
  double percentageTextColor = 0;
  final ValueNotifier<bool> isAnimatingNotifier;
  final bool isShowingCentreCircle;
  final bool isShowingLegend;
  final Color centreCircleBackgroundColor;
  final TextStyle centreCirclePercentageTextStyle;
  final TextStyle centreCircleSubtitleTextStyle;
  final String centreCircleTitle;

  Paint solidColorPaint = Paint();
  Paint legendLinePaint = Paint();
  Path legendPath = Path();
  Path flowerPath = Path();
  int viewStyle = ViewStyle.DOMINANT_WHITE;
  Rect textMeasureRect = const Rect.fromLTRB(0, 0, 80, 0);
  DrawFlowerPainter({
    required this.context,
    required this.overallPct,
    required this.endColors,
    required this.initialRotateOffset,
    required this.isAnimatingNotifier,
    required this.numSubjects,
    required this.petalInnerRadius,
    required this.petalOuterRadius,
    required this.rotateAngle,
    required this.scaleFactors,
    required this.animationDuration,
    required this.animationStart,
    required this.shouldDraw,
    required this.startColors,
    required this.subjectPercentages,
    required this.subjects,
    required this.canvasCx,
    required this.canvasCy,
    required this.centerCircleRectF,
    required this.isShowingCentreCircle,
    required this.isShowingLegend,
    required this.centreCircleBackgroundColor,
    required this.centreCirclePercentageTextStyle,
    required this.centreCircleSubtitleTextStyle,
    required this.centreCircleTitle,
  }) : super(repaint: isAnimatingNotifier);

  @override
  void paint(Canvas canvas, Size size) {
    if (!shouldDraw) {
      return;
    }

    final lapsedTime = math.min(
        DateTime.now().millisecondsSinceEpoch - animationStart,
        animationDuration);
    final isAnimating = lapsedTime < animationDuration;

    final currentRotateAngleInRad =
        rotateAngle * DEGREE_IN_RAD * lapsedTime / animationDuration;
    final cubicControlPointAngle = currentRotateAngleInRad / 3;

    for (int i = 0; i < numSubjects; i++) {
      final isVerticalPetal = (i % 2) == 0;
      final inverseGradient = (i == 2 || i == 3);
      solidColorPaint.color = startColors[i];
      solidColorPaint.shader = LinearGradient(
        begin: isVerticalPetal ? Alignment.bottomCenter : Alignment.centerRight,
        end: isVerticalPetal ? Alignment.topCenter : Alignment.centerLeft,
        colors: inverseGradient
            ? [endColors[i], startColors[i]]
            : [startColors[i], endColors[i]],
      ).createShader(centerCircleRectF);
      drawPetal(canvas, cubicControlPointAngle, currentRotateAngleInRad, i, 1,
          solidColorPaint);

      solidColorPaint.shader = null;

      solidColorPaint.color = TRANSPARENT_BLACK;

      if (isShowingCentreCircle) {
        drawPetal(canvas, cubicControlPointAngle, currentRotateAngleInRad, i,
            scaleFactors[i], solidColorPaint);
      }

      if (isShowingLegend) {
        if (!isAnimating) {
          drawLegend(canvas, i, scaleFactors[i]);
        }
      }
      if (isShowingCentreCircle) {
        drawCenterCircle(canvas, isAnimating);
      }

      if (isAnimating) {
        shouldRepaint;
      }

      if (isAnimatingNotifier.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          isAnimatingNotifier.notifyListeners();
        });
      }
    }
  }

  void drawCenterCircle(Canvas canvas, bool isAnimating) {
    solidColorPaint.color = centreCircleBackgroundColor;
    canvas.drawArc(centerCircleRectF, 0, 2 * math.pi, true, solidColorPaint);

    if (!isAnimating) {
      if (viewStyle != ViewStyle.DOMINANT_WHITE) {
        final titleTextSpan = TextSpan(
          text: "${overallPct.toInt()}%\n",
          style: centreCirclePercentageTextStyle,
        );
        final subtitleTextSpan = TextSpan(
          text: centreCircleTitle,
          style: centreCircleSubtitleTextStyle,
        );
        final textPainter = TextPainter(
          textAlign: TextAlign.center,
          text: TextSpan(children: [titleTextSpan, subtitleTextSpan]),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        final x = canvasCx - (textPainter.width / 2);
        final y = canvasCy - (textPainter.height / 2);
        textPainter.paint(canvas, Offset(x, y));
      } else {
        final textSpan = TextSpan(
          text: "${overallPct.toInt()}%\n",
          style: centreCirclePercentageTextStyle,
        );
        final subtitleTextSpan = TextSpan(
          text: centreCircleTitle,
          style: centreCircleSubtitleTextStyle,
        );
        final textPainter = TextPainter(
          textAlign: TextAlign.center,
          text: TextSpan(children: [textSpan, subtitleTextSpan]),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        final x = canvasCx - (textPainter.width / 2);
        final y = canvasCy - (textPainter.height / 2);
        final offset = Offset(x, y);
        textPainter.paint(canvas, offset);
      }
    }
  }

  void drawPetal(
      Canvas canvas,
      double cubicControlPointAngle,
      double currentRotateAngleInRad,
      int petalNumber,
      double scaleFactor,
      Paint paint) {
    double outerRadius = petalOuterRadius * scaleFactor;
    double innerRadius = petalInnerRadius * scaleFactor;
    flowerPath.reset();

    flowerPath.moveTo(canvasCx, canvasCy);
    flowerPath.relativeLineTo(outerRadius, 0);
    flowerPath.relativeCubicTo(
      outerRadius * (math.cos(cubicControlPointAngle) - 1),
      outerRadius * math.sin(cubicControlPointAngle),
      outerRadius * (math.cos(2 * cubicControlPointAngle) - 1),
      outerRadius * math.sin(2 * cubicControlPointAngle),
      -outerRadius + innerRadius * math.cos(currentRotateAngleInRad),
      innerRadius * math.sin(currentRotateAngleInRad),
    );
    flowerPath.lineTo(canvasCx, canvasCy);

    canvas.save();
    canvas.translate(canvasCx, canvasCy);
    canvas.rotate(
        (petalNumber * rotateAngle - initialRotateOffset) * DEGREE_IN_RAD);
    canvas.translate(-canvasCx, -canvasCy);
    canvas.drawPath(flowerPath, paint);
    canvas.restore();
  }

  void drawLegend(Canvas canvas, int petalNum, double scaleFactor) {
    double startAngleInRad =
        (petalNum * rotateAngle - initialRotateOffset) * DEGREE_IN_RAD;
    double halfRotateAngleInRad = rotateAngle * DEGREE_IN_RAD / 2;

    double startX = canvasCx +
        (scaleFactor *
            petalInnerRadius *
            math.cos(startAngleInRad + halfRotateAngleInRad));
    double startY = canvasCy +
        (scaleFactor *
            petalInnerRadius *
            math.sin(startAngleInRad + halfRotateAngleInRad));

    double endX = startX +
        (1.2 - scaleFactor) * petalOuterRadius * math.cos(startAngleInRad);
    double endY = startY +
        (1.2 - scaleFactor) * petalOuterRadius * math.sin(startAngleInRad);

    double rdx = textMeasureRect.width / 2 + 10;
    if (endX < canvasCx) {
      rdx = -rdx;
    }

    legendPath.reset();
    legendPath.moveTo(startX, startY);
    legendPath.lineTo(endX, endY);
    legendPath.relativeLineTo(rdx, 0);

    if (legendColor != 0) {
      legendLinePaint.color = Color(legendColor.toInt());
    } else {
      legendLinePaint.color = shadeColor(endColors[petalNum],
          viewStyle == ViewStyle.DOMINANT_PURPLE ? 0.05 : 0.55);
      legendLinePaint.style = PaintingStyle.stroke;
      legendLinePaint.strokeWidth = 2;
    }
    canvas.drawPath(legendPath, legendLinePaint);

    if (percentageTextColor != 0) {
      solidColorPaint.color = Color(percentageTextColor.toInt());
    } else {
      solidColorPaint.color = endColors[petalNum];
    }

    TextPainter percentagePainter = TextPainter(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "${subjectPercentages[petalNum]} %",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: solidColorPaint.color)),
      textDirection: TextDirection.ltr,
    );
    percentagePainter.layout();
    percentagePainter.paint(
      canvas,
      Offset(endX + rdx - 10, endY - (TextFontSize)),
    );

    if (subjectTextColor != 0) {
      solidColorPaint.color = Color(subjectTextColor.toInt());
    } else {
      solidColorPaint.color = Colors.black54;
    }

    TextPainter subjectPainter = TextPainter(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: subjects[petalNum],
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: solidColorPaint.color)),
      textDirection: TextDirection.ltr,
    );
    subjectPainter.layout();
    subjectPainter.paint(
      canvas,
      Offset(endX + rdx - 20, endY + (TextFontSize * 0.15)),
    );
  }

  Color shadeColor(Color color, double percent) {
    int t = percent < 0 ? 0 : 255;
    double p = percent < 0 ? -percent : percent;
    int red = color.red;
    int green = color.green;
    int blue = color.blue;
    int alpha = color.alpha;

    return Color.fromARGB(
      alpha,
      red + ((t - red) * p).toInt(),
      green + ((t - green) * p).toInt(),
      blue + ((t - blue) * p).toInt(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is DrawFlowerPainter) {
      return oldDelegate.overallPct != overallPct ||
          oldDelegate.shouldDraw != shouldDraw ||
          oldDelegate.numSubjects != numSubjects ||
          oldDelegate.petalInnerRadius != petalInnerRadius ||
          oldDelegate.petalOuterRadius != petalOuterRadius ||
          !listEquals(oldDelegate.subjectPercentages, subjectPercentages) ||
          !listEquals(oldDelegate.startColors, startColors) ||
          !listEquals(oldDelegate.endColors, endColors) ||
          !listEquals(oldDelegate.subjects, subjects) ||
          !listEquals(oldDelegate.scaleFactors, scaleFactors) ||
          oldDelegate.rotateAngle != rotateAngle ||
          oldDelegate.initialRotateOffset != initialRotateOffset ||
          oldDelegate.animationDuration != animationDuration ||
          oldDelegate.animationStart != animationStart ||
          oldDelegate.canvasCx != canvasCx ||
          oldDelegate.canvasCy != canvasCy ||
          oldDelegate.centerCircleRectF != centerCircleRectF;
    }
    return true;
  }
}
