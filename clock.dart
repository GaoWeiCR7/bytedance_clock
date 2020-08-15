import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ClockPage extends StatefulWidget {
  final double radius;
  final Color pointColor;
  final Color numberColor;
  final Color borderColor;

  const ClockPage(
      {Key key,
        this.pointColor,
        this.numberColor,
        this.borderColor,
        this.radius = 150.0})
      : super(key: key);

  @override
  ClockPageState createState() => ClockPageState();
}

class ClockPageState extends State<ClockPage> {
  DateTime datetime;
  Timer timer;

  @override
  void initState() {
    super.initState();
    datetime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        datetime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockPainter(datetime,
          numberColor: Colors.white,
          pointColor: Colors.yellow,
          borderColor: Colors.white,
          radius: widget.radius),
      size: Size(widget.radius * 2, widget.radius * 2),
    );
  }
}

class ClockPainter extends CustomPainter {
  final Color pointColor;
  final Color numberColor;
  final Color borderColor;
  final double radius;
  List<Offset> secondsOffset = [];
  final DateTime datetime;
  TextPainter textPainter;
  double angle;
  double borderWidth;

  ClockPainter(this.datetime,
      {this.radius = 150.0,
        this.pointColor = Colors.yellow,
        this.numberColor = Colors.white,
        this.borderColor = Colors.white}) {
    borderWidth = radius / 150;
    final secondDistance = radius - borderWidth * 15;
    //init seconds offset
    for (var i = 0; i < 60; i++) {
      Offset offset = Offset(
          cos(degToRad(6 * i - 90)) * secondDistance + radius,
          sin(degToRad(6 * i - 90)) * secondDistance + radius);
      secondsOffset.add(offset);
    }

    textPainter = new TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
    angle = degToRad(360 / 60);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scale = radius / 150;

    //draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(
        Offset(radius, radius), radius - borderWidth / 2, borderPaint);

    //draw second point
    final secondPPaint = Paint()
      ..strokeWidth = 2 * scale
      ..color = numberColor;
    if (secondsOffset.length > 0) {
      canvas.drawPoints(PointMode.points, secondsOffset, secondPPaint);

      List<Offset> bigger = [];
      for (var i = 0; i < secondsOffset.length; i++) {
        if (i % 5 == 0) {
          bigger.add(secondsOffset[i]);
        }
      }

      final biggerPaint = Paint()
        ..strokeWidth = 5 * scale
        ..color = numberColor;
      canvas.drawPoints(PointMode.points, bigger, biggerPaint);
    }

    final hour = datetime.hour;
    final minute = datetime.minute;
    final second = datetime.second;

    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w200,
      fontStyle: FontStyle.normal,
      fontSize: 80,
    ));


    pb.pushStyle(ui.TextStyle(color: Colors.white));
    pb.addText('${hour>9?hour:'0'+hour.toString()}:${minute>9?minute:'0'+minute.toString()}');
    ParagraphConstraints pc = ParagraphConstraints(width: 2*radius-80);
    Paragraph paragraph = pb.build()..layout(pc);
    Offset offset = Offset(radius-110, radius-40);
    canvas.drawParagraph(paragraph, offset);

    final pointPaint = Paint()
    ..color = pointColor
    ..style = PaintingStyle.fill;

    Offset point = Offset(
        radius +
            cos(degToRad(360 / 60 * second - 90)) * radius,
        radius +
            sin(degToRad(360 / 60 * second - 90)) * radius
    );
    canvas.drawCircle(point, 5*scale, pointPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

num degToRad(num deg) => deg * (pi / 180.0);
