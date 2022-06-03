import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData lineChartModel() {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  return LineChartData(
    borderData: FlBorderData(
      show: false,
    ),
    gridData: FlGridData(
        show: true,
        horizontalInterval: 1.6,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            dashArray: const [3, 3],
            color: const Color(0xff37434d).withOpacity(0.2),
            strokeWidth: 2,
          );
        },
        drawVerticalLine: false),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 11),
        getTitles: (value) {
          switch (value.toInt()) {
            case 0:
              return 'MAR';
            case 4:
              return 'JUN';
            case 8:
              return 'SEP';
            case 11:
              return 'OCT';
          }
          return '';
        },
        margin: 10,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '10k';
            case 3:
              return '30k';
            case 5:
              return '50k';
          }
          return '';
        },
        reservedSize: 25,
        margin: 12,
      ),
    ),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 3),
          FlSpot(2.4, 2),
          FlSpot(4.4, 3),
          FlSpot(6.4, 3.1),
          FlSpot(8, 4),
          FlSpot(9.5, 4),
          FlSpot(11, 5),
        ],
        isCurved: true,
        colors: gradientColors,
        barWidth: 2,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
            show: true,
            gradientFrom: Offset(0, 0),
            gradientTo: Offset(0, 1),
            colors: [
              Color(0xff02d39a).withOpacity(0.1),
              Color(0xff02d39a).withOpacity(0),
            ]),
      ),
    ],
  );
}
