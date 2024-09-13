import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TagPieChart extends StatelessWidget {
  const TagPieChart({
    super.key,
    required this.values
  });

  final Map<String, double> values;
  static const List<Color> colorList = [
    Colors.blue, Colors.green, Color.fromARGB(255, 167, 59, 255), Colors.grey, Color.fromARGB(255, 215, 255, 82)
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
      const fontSize = 16.0;
      sections.add(PieChartSectionData(
        radius: 100,
        color: color,
        value: values[name],
        title: name,
        titlePositionPercentageOffset: 0.5,
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
