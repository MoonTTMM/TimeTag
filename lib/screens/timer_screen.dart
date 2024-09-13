import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tag/main.dart';
import '../db/task_database.dart';
import '../models/task.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  final _uuid = const Uuid();
  final _textFieldController = TextEditingController();
  late String _currentTask;
  late String _startTime;
  Timer? _timer;

  String _formattedTime(Stopwatch stopwatch) {
    final elapsed = stopwatch.elapsed;
    String hours = (elapsed.inHours).toString().padLeft(2, '0');
    String minutes = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void _stopAndSaveTask(Stopwatch stopwatch) async {
    if (_currentTask.isNotEmpty) {
      final duration = stopwatch.elapsed.inMinutes.toString();
      final task = Task(id: _uuid.v4(), taskName: _currentTask, startTime: _startTime, duration: duration);
      await TaskDatabase.instance.insertTask(task);
      _textFieldController.clear();

      setState(() {
        stopwatch.reset();
        _currentTask = '';
        _startTime = DateTime.now().toIso8601String();
      });
    }
  }

  void _reset(Stopwatch stopwatch) {
    _textFieldController.clear();
    setState(() {
      stopwatch.reset();
      _currentTask = '';
      _startTime = DateTime.now().toIso8601String();
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {});
    });
    _startTime = DateTime.now().toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    var stopwatch = Provider.of<MyAppState>(context).stopwatch;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
              _formattedTime(stopwatch),
              style: const TextStyle(fontSize: 100),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Your tag'),
              controller: _textFieldController,
              onChanged: (value) {
                _currentTask = value;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                  ),
                  onPressed: (){
                    _stopAndSaveTask(stopwatch);
                  },
                  child: const Text(
                    'Record',
                    style: TextStyle(color: Colors.white)
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    _reset(stopwatch);
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
