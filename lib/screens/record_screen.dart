import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tag/main.dart';
import '../db/task_database.dart';
import '../models/task.dart';
import '../widgets/pie_chart.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  RecordScreenState createState() => RecordScreenState();
}

class RecordScreenState extends State<RecordScreen> {
  late Future<List<Task>> _taskRecords;
  DateTime? _startDate;
  DateTime? _endDate;
  late MyAppState appState;

  @override
  void initState() {
    super.initState();

    appState = Provider.of<MyAppState>(context, listen: false);
    _startDate = appState.startDate;
    _endDate = appState.endDate;
    _taskRecords = TaskDatabase.instance.fetchTasks(startDate: _startDate, endDate: _endDate);
  }

  // 选择日期的函数
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate?_startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 0, 0, 0);
          appState.startDate = _startDate!;
        } else {
          _endDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 23, 59,59);
          appState.endDate = _endDate!;
        }
        _taskRecords = TaskDatabase.instance.fetchTasks(startDate: _startDate, endDate: _endDate);
      });
    }
  }

  void deleteTag(String id) async {
    await TaskDatabase.instance.deleteTask(id);
    setState(() {
      _taskRecords = TaskDatabase.instance.fetchTasks(startDate: _startDate, endDate: _endDate);
    });
  }

  Map<String, double> sumTimeByTag(List<Task> tasks){
    var map = <String, double>{};
    for (var task in tasks) {
      var name = task.taskName;
      if (!map.containsKey(name)) {
        map[name] = 0;
      }
      map[name] = map[name]! + double.parse(task.duration);
    }
    return map;
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' Time Flies ...',
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        actions: [
          ElevatedButton(
            onPressed: () => _selectDate(context, true), 
            child: Text('from: ${formatDate(_startDate)}')
          ),
          const Text(' '),
          ElevatedButton(
            onPressed: () => _selectDate(context, false), 
            child: Text('to: ${formatDate(_endDate)}')
          ),
          const Text('  ')
        ],
      ),
      body: 
          FutureBuilder<List<Task>>(
            future: _taskRecords,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(child: Text('No records found'));
              } else {
                final tasks = snapshot.data ?? [];
                final map = sumTimeByTag(tasks);
                final totalDuration = map.values.reduce((sum, value) => sum + value);
                var hours = (totalDuration / 60).round();
                var mins = (totalDuration % 60).round();
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 600,
                        child:ListView(
                          children: [
                            for (var task in tasks)
                              ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blue),
                                          borderRadius: BorderRadius.circular(3.0),
                                        ),
                                        child: Text(
                                          task.taskName,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      )
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteTag(task.id);
                                      }, 
                                      color: Colors.blue,
                                      icon: const Icon(Icons.delete))
                                  ],
                                ),
                                subtitle: Text('Duration: ${task.duration} mins, Start: ${task.startTime}'),
                              )
                          ],
                    ))),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Total:""$hours""h""$mins""m    ",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: TagPieChart(values: map))
                        ],
                      )
                    )
                  ],
                );
              }
            },
          )
    );
  }
}
