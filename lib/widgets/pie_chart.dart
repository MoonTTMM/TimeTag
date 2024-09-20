import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TagPieChart extends StatelessWidget {
  const TagPieChart({
    super.key,
    required this.values
  });

  final Map<String, double> values;
  static const List<Color> colorList = [
    Color.fromARGB(255, 91, 143, 249), 
    Color.fromARGB(255, 97, 221, 170), 
    Color.fromARGB(255, 101, 120, 155), 
    Color.fromARGB(255, 246, 189, 21), 
    Color.fromARGB(255, 114, 98, 253),
    Color.fromARGB(255, 120, 211, 248),
    Color.fromARGB(255, 150, 97, 188),
    Color.fromARGB(255, 246, 144, 61),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> sections = [];
    var count = 0;
    var colorSize = colorList.length;
    for (var name in values.keys) {
      var color = colorList[count % colorSize];
      var duration = values[name];
      var hours = (duration! / 60).round();
      var mins = (duration % 60).round();
      const fontSize = 12.0;
      sections.add(PieChartSectionData(
        radius: 100,
        color: color,
        value: duration,
        title: "$name\n$hours""h$mins""m",
        titlePositionPercentageOffset: 0.8,
        showTitle: true,
        titleStyle: const TextStyle(
          fontSize: fontSize,
          color: Colors.black,
        ),
      ));
      count++;
    }
    return sections;
  }
}

void main() => runApp(const MaterialApp(home: Scaffold(body: TagPieChart(
  values: {'key1': 10.0, 'key2': 20.0}
))));
