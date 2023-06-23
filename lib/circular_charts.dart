library circular_charts;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'circular_painter.dart';

class CircularChart extends StatefulWidget {
  final double? overAllPercentage;
  final String? centreCircleTitle;
  final List<double> pieChartPercentages;
  final List<Color> pieChartStartColors;
  final List<Color> pieChartEndColors;
  final List<String> pieChartChildNames;
  final double chartWidth;
  final double chartHeight;
  final double animationTime;
  final bool? isShowingCentreCircle;
  final bool? isShowingLegend;
  final Color? centreCircleBackgroundColor;
  final TextStyle? centreCirclePercentageTextStyle;
  final TextStyle? centreCircleSubtitleTextStyle;
  const CircularChart({
    super.key,
    required this.animationTime,
    required this.chartWidth,
    required this.chartHeight,
    this.overAllPercentage = 0,
    required this.pieChartEndColors,
    required this.pieChartChildNames,
    required this.pieChartPercentages,
    required this.pieChartStartColors,
    this.centreCircleTitle = "",
    this.isShowingCentreCircle = false,
    this.isShowingLegend = false,
    this.centreCircleBackgroundColor,
    this.centreCirclePercentageTextStyle,
    this.centreCircleSubtitleTextStyle,
  });

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart>
    with SingleTickerProviderStateMixin {
  bool shouldDraw = false;
  late int numSubjects;
  late double petalInnerRadius;
  late double petalOuterRadius;
  late List<double> subjectPercentages;
  late List<Color> startColors;
  late List<Color> endColors;
  late List<String> subjects;
  late List<double> scaleFactors = [];
  late double rotateAngle = 0;
  late double initialRotateOffset;
  late double animationStart = -1;
  late double canvasCx;
  late double canvasCy;
  late Rect centerCircleRectF;
  late double overallPct;
  late double centerCircleRadius;

  List<double> initialRotateOffsets = [0, 90, -30, 45, 36, 30, 0, 22.5];

  late AnimationController _controller;
  // ignore: unused_field
  late Animation<double> _animation;

  @override
  void didUpdateWidget(CircularChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chartWidth != oldWidget.chartWidth ||
        widget.chartHeight != oldWidget.chartHeight) {
      initFlowerChart();
      _controller.duration =
          Duration(milliseconds: widget.animationTime.toInt());
      _controller.reset();
      _controller.forward();
    }
  }

  void initFlowerChart() {
    setState(() {
      animationStart = DateTime.now().millisecondsSinceEpoch.toDouble();
      final overallText = TextSpan(
        text: widget.centreCircleTitle,
        style: widget.centreCircleSubtitleTextStyle ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
      );
      final textPainter = TextPainter(
        textAlign: TextAlign.center,
        text: overallText,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      double centerCircleRadius = textPainter.width * 0.4;
      centerCircleRadius = centerCircleRadius;
      petalOuterRadius =
          math.min(widget.chartWidth * 0.26, widget.chartHeight * 0.4);
      petalInnerRadius = (petalOuterRadius * 0.85);
      subjectPercentages = widget.pieChartPercentages;
      startColors = widget.pieChartStartColors;
      endColors = widget.pieChartEndColors;
      subjects = widget.pieChartChildNames;
      overallPct = widget.overAllPercentage!.toDouble();
      numSubjects = math.min(
          math.min(widget.pieChartPercentages.length,
              widget.pieChartStartColors.length),
          widget.pieChartChildNames.length.toInt());

      for (int i = 0; i < numSubjects; i++) {
        double scaleFactor = math.sqrt(centerCircleRadius * centerCircleRadius +
                subjectPercentages[i] *
                    (petalOuterRadius * petalOuterRadius -
                        centerCircleRadius * centerCircleRadius) /
                    100) /
            petalOuterRadius;
        scaleFactors.add(scaleFactor);
      }
      rotateAngle = 360 / numSubjects;
      initialRotateOffset = initialRotateOffsets[numSubjects - 1];
      shouldDraw = true;
      canvasCx = widget.chartWidth / 2.0;
      canvasCy = widget.chartHeight / 2.0;
      centerCircleRectF = Rect.fromCircle(
        center: Offset(canvasCx, canvasCy),
        radius: centerCircleRadius,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initFlowerChart();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.animationTime.toInt()),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true,
      size: Size(widget.chartWidth.toDouble(), widget.chartHeight.toDouble()),
      painter: DrawFlowerPainter(
          isAnimatingNotifier: ValueNotifier(true),
          context: context,
          overallPct: widget.overAllPercentage!.toDouble(),
          canvasCx: canvasCx,
          canvasCy: canvasCy,
          centerCircleRectF: centerCircleRectF,
          animationDuration: widget.animationTime.toDouble(),
          animationStart: animationStart,
          endColors: endColors,
          initialRotateOffset: initialRotateOffset,
          numSubjects: numSubjects,
          petalInnerRadius: petalInnerRadius,
          petalOuterRadius: petalOuterRadius,
          rotateAngle: rotateAngle,
          scaleFactors: scaleFactors,
          shouldDraw: shouldDraw,
          startColors: startColors,
          subjectPercentages: subjectPercentages,
          subjects: subjects,
          isShowingCentreCircle: widget.isShowingCentreCircle ?? false,
          isShowingLegend: widget.isShowingLegend ?? false,
          centreCircleBackgroundColor: widget.centreCircleBackgroundColor ??
              Colors.white,
          centreCirclePercentageTextStyle:
              widget.centreCirclePercentageTextStyle ??
                  const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
          centreCircleSubtitleTextStyle: widget.centreCircleSubtitleTextStyle ??
              const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
          centreCircleTitle: widget.centreCircleTitle ?? "Overall"),
    );
  }
}
