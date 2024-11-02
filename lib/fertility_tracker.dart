import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class FertilityTrackerPage extends StatefulWidget {
  const FertilityTrackerPage({super.key});

  @override
  FertilityTrackerPageState createState() => FertilityTrackerPageState();
}

class FertilityTrackerPageState extends State<FertilityTrackerPage> {
  DateTime? selectedCycleStartDate;
  bool symptomTracking = false;
  List<String> symptoms = []; // List to hold logged symptoms
  List<TrackingEntry> trackingEntries = []; // List to hold tracking entries
  String selectedSymptom = ''; // Currently selected symptom

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fertility Tracker"),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF48FB1), Color(0xFFF06292), Color(0xFFEC407A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildCycleStartCard(),
              const SizedBox(height: 20),
              _buildSymptomTrackingCard(),
              const SizedBox(height: 20),
              _buildFertilityWindowCard(),
              const SizedBox(height: 20),
              _buildTrackingLog(),
              const SizedBox(height: 20),
              _buildClearAllButton(),
            ].animate().fadeIn(duration: 600.ms).slide(begin: const Offset(0, 0.2)),
          ),
        ),
      ),
    );
  }

  Widget _buildCycleStartCard() {
    return GestureDetector(
      onTap: () => _selectCycleStartDate(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Cycle Start Date",
                style: TextStyle(
                  color: Color(0xFFD81B60),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                selectedCycleStartDate != null
                    ? DateFormat('MMMM dd, yyyy').format(selectedCycleStartDate!)
                    : "No date selected",
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.calendar_today, color: Color(0xFFD81B60), size: 28),
            ],
          ),
        ),
      ).animate().fade(duration: 500.ms).slide(begin: const Offset(0, -0.1)),
    );
  }

  Widget _buildSymptomTrackingCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Symptom Tracking",
              style: TextStyle(
                color: Color(0xFFD81B60),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Track Symptoms",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Switch(
                  activeColor: const Color(0xFFF06292),
                  value: symptomTracking,
                  onChanged: (value) {
                    setState(() {
                      symptomTracking = value;
                    });
                  },
                ).animate().slide(begin: const Offset(-0.3, 0)).fade(),
              ],
            ),
            if (symptomTracking) ...[
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  selectedSymptom = value;
                },
                decoration: InputDecoration(
                  labelText: "Enter Symptom",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _logSymptom,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.pinkAccent,
                ),
                child: const Text('Log Symptom'),
              ),
            ],
          ],
        ),
      ).animate().fade(duration: 600.ms).slide(begin: const Offset(0, 0.1)),
    );
  }

  void _logSymptom() {
    if (selectedSymptom.isNotEmpty) {
      setState(() {
        symptoms.add(selectedSymptom);
        // Add a new tracking entry
        trackingEntries.add(TrackingEntry(
          date: DateTime.now(),
          symptom: selectedSymptom,
        ));
        selectedSymptom = ''; // Clear input
      });
    }
  }

  Widget _buildFertilityWindowCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Fertility Window",
              style: TextStyle(
                color: Color(0xFFD81B60),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedCycleStartDate != null
                  ? "Estimated Fertility Window: ${calculateFertilityWindow(selectedCycleStartDate!)}"
                  : "Select a cycle start date to estimate your fertility window.",
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ],
        ),
      ).animate().fade(duration: 800.ms).slide(begin: const Offset(0, 0.1)),
    );
  }

  Widget _buildTrackingLog() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tracking Log",
              style: TextStyle(
                color: Color(0xFFD81B60),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...trackingEntries.map((entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${DateFormat('MMMM dd, yyyy').format(entry.date)}'),
                Text('Symptom: ${entry.symptom}'),
                const Divider(),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildClearAllButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _clearAll,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent, // Button color
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Clear All",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _clearAll() {
    setState(() {
      selectedCycleStartDate = null;
      symptomTracking = false;
      symptoms.clear();
      trackingEntries.clear();
    });
  }

  Future<void> _selectCycleStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedCycleStartDate) {
      setState(() {
        selectedCycleStartDate = picked;
      });
    }
  }

  String calculateFertilityWindow(DateTime cycleStartDate) {
    final ovulationDate = cycleStartDate.add(const Duration(days: 14));
    final startWindow = ovulationDate.subtract(const Duration(days: 2));
    final endWindow = ovulationDate.add(const Duration(days: 2));
    return "${DateFormat('MMMM dd').format(startWindow)} - ${DateFormat('MMMM dd').format(endWindow)}";
  }
}

class TrackingEntry {
  final DateTime date; // Date of the symptom
  final String symptom; // Logged symptom

  TrackingEntry({required this.date, required this.symptom});
}
