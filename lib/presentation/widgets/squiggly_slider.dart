import 'package:flutter/material.dart';
import 'dart:math';


class SquigglySlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final double squiggleAmplitude;
  final double squiggleWavelength;
  final double squiggleSpeed;
  final String label;
  final ValueChanged<double> onChanged;

  const SquigglySlider({
    Key? key,
    required this.value,
    this.min = 0,
    this.max = 30,
    this.squiggleAmplitude = 5,
    required this.squiggleWavelength,
    this.squiggleSpeed = 0.5,
    this.label = '',
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SquigglySlider> createState() => _SquigglySliderState();
}

class _SquigglySliderState extends State<SquigglySlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = details.localPosition.dx;
              final width = box.size.width;
              final newValue =
                  widget.min +
                  (localPosition / width) * (widget.max - widget.min);
              widget.onChanged(newValue.clamp(widget.min, widget.max));
            },
            child: CustomPaint(
              painter: SquigglySliderPainter(
                value: widget.value,
                min: widget.min,
                max: widget.max,
                squiggleAmplitude: widget.squiggleAmplitude,
                squiggleWavelength: widget.squiggleWavelength,
                animationValue: _controller.value * widget.squiggleSpeed * 100,
              ),
              child: Container(),
            ),
          );
        },
      ),
    );
  }
}

class SquigglySliderPainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final double squiggleAmplitude;
  final double squiggleWavelength;
  final double animationValue;

  SquigglySliderPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.squiggleAmplitude,
    required this.squiggleWavelength,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final fillPercent = (value - min) / (max - min);
    final fillX = size.width * fillPercent;

    // Draw active track (left side - squiggly with animation)
    paint.color = const Color(0xFF1B6EF3);
    final activePath = Path();
    bool firstActive = true;

    // Always calculate wave based on absolute position with animation
    for (double x = 0; x <= fillX; x += 1) {
      final wave =
          sin((x / squiggleWavelength) + (animationValue * 2 * pi)) *
          squiggleAmplitude;
      final y = centerY + wave;

      if (firstActive) {
        activePath.moveTo(x, y);
        firstActive = false;
      } else {
        activePath.lineTo(x, y);
      }
    }
    canvas.drawPath(activePath, paint);

    // Draw inactive track (right side - straight)
    paint.color = const Color(0xFFE3E3E8);
    canvas.drawLine(Offset(fillX, centerY), Offset(size.width, centerY), paint);

    // Calculate thumb position on the wave at its current x position with animation
    // final thumbWave =
    //     sin((fillX / squiggleWavelength) + (animationValue * 2 * pi)) *
    //     squiggleAmplitude;
    final thumbY = centerY;

    // Draw thumb shadow
    final shadowPaint = Paint()
      ..color = const Color(0xFF1B6EF3).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(Offset(fillX, thumbY + 2), 10, shadowPaint);

    // Draw thumb
    final thumbPaint = Paint()
      ..color = const Color(0xFF1B6EF3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(fillX, thumbY), 10, thumbPaint);
  }

  @override
  bool shouldRepaint(SquigglySliderPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.squiggleWavelength != squiggleWavelength;
  }
}
