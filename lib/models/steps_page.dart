import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({super.key});

  @override
  StepsPageState createState() => StepsPageState();
}

class StepsPageState extends State<StepsPage> {
  late Stream<StepCount> _stepCountStream;
  int stepsToday = 0; // Initialize step count
  final int stepGoal = 10000; // Example daily goal

  @override
  void initState() {
    super.initState();
    _startStepCount();
  }

  void _startStepCount() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount stepCount) {
      setState(() {
        stepsToday += stepCount.steps; // Update the step count
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (stepsToday / stepGoal).clamp(0.0, 1.0); // Calculate progress

    return Scaffold(
      appBar: AppBar(
        title: const Text('Steps Tracker'), // Title of the page
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF80DEEA), // Light Teal
              Color(0xFFFFABAB), // Light Pink
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                  child: Text(
                    '$stepsToday / $stepGoal steps',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Dark color for contrast
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Keep going to reach your daily goal!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54, // Dark gray for better readability
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Icon(
                    Icons.directions_walk, // Icon representing walking
                    size: 80,
                    color: Colors.teal, // Match the theme
                  ),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white,
                  color: Colors.teal,
                  minHeight: 12,
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    '"Every step counts!"', // Motivational quote
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFABAB), // Light Pink
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Optionally, you could log the step count here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Keep stepping up!')),
                      );
                    },
                    child: const Text(
                      'Motivate Me!',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
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
