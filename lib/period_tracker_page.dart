import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PeriodTrackerPage extends StatefulWidget {
  const PeriodTrackerPage({super.key});

  @override
  PeriodTrackerPageState createState() => PeriodTrackerPageState();
}

class TrackingEntry {
  final int cycleDay;
  final String? flowType;
  final List<String> symptoms;

  TrackingEntry({required this.cycleDay, this.flowType, required this.symptoms});
}

class PeriodTrackerPageState extends State<PeriodTrackerPage> {
  int cycleDay = 1;
  bool isTracking = false;
  String? flowType;
  List<String> selectedSymptoms = [];
  List<TrackingEntry> trackingEntries = []; // List to store tracking entries

  final List<String> symptoms = [
    'Cramping',
    'Bloating',
    'Fatigue',
    'Headache',
    'Mood Swings',
    'Back Pain',
    'Nausea',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Period Tracker',
          style: TextStyle(color: Colors.pink),
        ),
        centerTitle: true,
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
              _buildCycleInfoCard(),
              const SizedBox(height: 20),
              _buildCycleProgressIndicator(),
              const SizedBox(height: 20),
              _buildTipsCard(),
              const SizedBox(height: 20),
              _buildFlowTracker(),
              const SizedBox(height: 20),
              _buildSymptomTracker(),
              const SizedBox(height: 20),
              _buildTrackButton(),
              const SizedBox(height: 20),
              _buildLoggedEntries(), // Display logged entries
              const SizedBox(height: 40),
            ].animate().fadeIn(duration: 1000.ms).slide(begin: const Offset(0, 0.3)),
          ),
        ),
      ),
    );
  }

  Widget _buildCycleInfoCard() {
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
          Text(
            'Cycle Day $cycleDay',
            style: const TextStyle(
              color: Colors.pinkAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'You are currently in the ${_getCyclePhase()} phase',
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.8, end: 1.0);
  }

  Widget _buildCycleProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.pinkAccent.shade100,
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
            'Cycle Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: cycleDay / 28,
            color: Colors.pinkAccent,
            backgroundColor: const Color(0x4DFFFFFF),
          ).animate().slide(begin: const Offset(-0.5, 0)).fadeIn(),
          const SizedBox(height: 10),
          Text(
            '$cycleDay of 28 days',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ).animate().scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)).fadeIn(),
    );
  }

  Widget _buildTipsCard() {
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
            'Today’s Tip',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _getCycleTip(),
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 900.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
  }

  Widget _buildFlowTracker() {
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
            'Flow Tracker',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Record your flow for today:',
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            items: <String>['Heavy', 'Light', 'Spotting', 'None']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                flowType = value;
              });
            },
            hint: const Text('Select Flow Type'),
            value: flowType,
            isExpanded: true,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 700.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
  }

  Widget _buildSymptomTracker() {
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
            'Symptom Tracker',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Select your symptoms:',
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: symptoms.map((symptom) {
              return ChoiceChip(
                label: Text(symptom),
                selected: selectedSymptoms.contains(symptom),
                onSelected: (selected) {
                  setState(() {
                    selected ? selectedSymptoms.add(symptom) : selectedSymptoms.remove(symptom);
                  });
                },
                selectedColor: Colors.pinkAccent,
                backgroundColor: Colors.grey[300],
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
  }

  Widget _buildTrackButton() {
    return ElevatedButton(
      onPressed: _logTrackingData,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.pink,
      ),
      child: const Text('Track Today\'s Data'),
    );
  }

  Widget _buildLoggedEntries() {
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
            'Logged Entries',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          for (var entry in trackingEntries)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cycle Day: ${entry.cycleDay}'),
                Text('Flow Type: ${entry.flowType ?? 'Not specified'}'),
                Text('Symptoms: ${entry.symptoms.join(', ')},'),
                const Divider(),
              ],
            ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
  }

  String _getCyclePhase() {
    if (cycleDay <= 7) {
      return 'Menstrual Phase';
    } else if (cycleDay <= 14) {
      return 'Follicular Phase';
    } else if (cycleDay <= 21) {
      return 'Ovulatory Phase';
    } else {
      return 'Luteal Phase';
    }
  }

  String _getCycleTip() {
    // You can customize tips based on the cycle phase
    return 'Stay hydrated and maintain a balanced diet!';
  }

  void _logTrackingData() {
    // Create a new tracking entry
    TrackingEntry newEntry = TrackingEntry(
      cycleDay: cycleDay,
      flowType: flowType,
      symptoms: List.from(selectedSymptoms), // Create a copy of selected symptoms
    );

    // Add the entry to the list
    setState(() {
      trackingEntries.add(newEntry);
      // Reset the tracking fields
      flowType = null;
      selectedSymptoms.clear();
      cycleDay++;
    });
  }
}
