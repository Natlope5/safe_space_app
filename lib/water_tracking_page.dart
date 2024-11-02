import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:logger/logger.dart';

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  WaterTrackerPageState createState() => WaterTrackerPageState();
}

class WaterTrackerPageState extends State<WaterTrackerPage> {
  int waterIntake = 0; // in milliliters
  final int dailyGoal = 2000; // Daily water intake goal in milliliters
  final TextEditingController _controller = TextEditingController(); // Controller for TextField
  final Logger logger = Logger();

  // Method to reset water intake
  void _resetIntake() {
    setState(() {
      waterIntake = 0; // Resetting the water intake
    });
    _controller.clear(); // Clear the input field
    logger.i("Water intake has been reset."); // Log reset action
  }

  // Method to add water intake
  void _addWaterIntake(String value) {
    int inputAmount = int.tryParse(value) ?? 0;

    if (inputAmount > 0) {
      setState(() {
        waterIntake += inputAmount; // Update water intake
      });
      logger.i("User added water intake: $inputAmount mL"); // Log the water amount added
      _controller.clear(); // Clear the input field after submission
    } else {
      logger.i("Invalid input: '$value'. Please enter a valid number."); // Log invalid input
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFff9a9e), Color(0xFFfad0c4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildIntakeCard(),
              const SizedBox(height: 20),
              _buildInputSection(),
              const SizedBox(height: 20),
              _buildLogSection(),
              const SizedBox(height: 40),
              _buildTipsSection(),
              const SizedBox(height: 40),
            ].animate().fadeIn(duration: 1000.ms).slide(begin: const Offset(0, 0.3)),
          ),
        ),
      ),
    );
  }

  Widget _buildIntakeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xB3FFFFFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x66FF4081),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Daily Water Intake',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$waterIntake mL',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: waterIntake / dailyGoal,
            color: Colors.pinkAccent,
            backgroundColor: const Color(0x4DFFFFFF),
          ).animate().slide(begin: const Offset(-0.5, 0)).fadeIn(),
          const SizedBox(height: 10),
          Text(
            'Goal: $dailyGoal mL',
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.8, end: 1.0),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xB3FFFFFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x66FF4081),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Water Intake',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controller, // Use the controller
            decoration: InputDecoration(
              hintText: 'Enter amount in mL',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.number,
            onSubmitted: _addWaterIntake, // Call the add function
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _resetIntake, // Reset the intake
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Reset Intake'),
          ),
        ],
      ).animate().fadeIn(duration: 900.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
    );
  }

  Widget _buildLogSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xB3FFFFFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x66FF4081),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Water Intake Log',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Total intake today: $waterIntake mL',
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ).animate().fadeIn(duration: 700.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xB3FFFFFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x66FF4081),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hydration Tips',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '1. Carry a water bottle with you to drink throughout the day.\n'
                '2. Set reminders to drink water every hour.\n'
                '3. Drink a glass of water before meals.\n'
                '4. Incorporate water-rich foods into your diet.',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
    );
  }
}
