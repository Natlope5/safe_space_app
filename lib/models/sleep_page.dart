import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepEntry {
  final DateTime date;
  final double hoursSlept;

  SleepEntry({required this.date, required this.hoursSlept});
}

class SleepPage extends StatefulWidget {
  const SleepPage({super.key}); // Example daily goal for sleep hours

  @override
  SleepPageState createState() => SleepPageState();
}

class SleepPageState extends State<SleepPage> {
  final double sleepGoal = 8.0;
  List<SleepEntry> sleepEntries = []; // List to store sleep entries

  // Function to log new sleep hours
  void _logSleep(double hours) {
    final today = DateTime.now();
    setState(() {
      sleepEntries.add(SleepEntry(date: today, hoursSlept: hours));
    });
  }

  // Function to show dialog for logging sleep hours
  Future<void> _showLogSleepDialog() async {
    double? hoursSlept;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Sleep Hours'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Hours Slept'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              hoursSlept = double.tryParse(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (hoursSlept != null) {
                  _logSleep(hoursSlept!);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid number.')),
                  );
                }
              },
              child: const Text('Log'),
            ),
          ],
        );
      },
    );
  }

  // Function to clear all sleep entries
  void _clearAllEntries() {
    setState(() {
      sleepEntries.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All sleep entries cleared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalHours = sleepEntries.fold(0, (sum, entry) => sum + entry.hoursSlept);
    double progress = (totalHours / sleepGoal).clamp(0.0, 1.0); // Calculate progress

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sleep Tracker',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2EBF2), Color(0xFF80DEEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.bedtime_rounded,
                        color: Colors.pink,
                        size: 80,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$totalHours / ${sleepGoal.toStringAsFixed(1)} hours',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Quality sleep is key to a healthy day!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, _) => Column(
                      children: [
                        LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.white30,
                          color: Colors.indigoAccent,
                          minHeight: 12,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${(value * 100).toStringAsFixed(0)}% of your goal',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _showLogSleepDialog,
                    child: const Text(
                      'Log Sleep Hours',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _clearAllEntries,
                    child: const Text(
                      'Clear All',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sleep Log:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: sleepEntries.length,
                    itemBuilder: (context, index) {
                      final entry = sleepEntries[index];
                      return ListTile(
                        title: Text(
                          DateFormat('yyyy-MM-dd').format(entry.date),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${entry.hoursSlept} hours'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
