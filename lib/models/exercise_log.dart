import 'package:flutter/material.dart';

class ExerciseLogPage extends StatefulWidget {
  const ExerciseLogPage({super.key});

  @override
  ExerciseLogPageState createState() => ExerciseLogPageState();
}

class ExerciseLogPageState extends State<ExerciseLogPage> {
  final List<Map<String, dynamic>> exercises = [
    {'name': 'Running', 'duration': 30}, // Example exercise data
    {'name': 'Yoga', 'duration': 60},
    {'name': 'Weightlifting', 'duration': 45},
  ];

  int? selectedExerciseIndex;

  // Method to add a new exercise to the list
  void _addExercise(String name, int duration) {
    setState(() {
      exercises.add({'name': name, 'duration': duration});
    });
  }

  // Method to clear all exercises
  void _clearAllExercises() {
    setState(() {
      exercises.clear();
    });
  }

  // Method to show a dialog for adding a new exercise
  Future<void> _showAddExerciseDialog() async {
    String? exerciseName;
    int? exerciseDuration;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                onChanged: (value) {
                  exerciseName = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  exerciseDuration = int.tryParse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (exerciseName != null && exerciseDuration != null) {
                  _addExercise(exerciseName!, exerciseDuration!);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid data.')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalDuration = exercises.fold(0, (sum, exercise) => exercise['duration'] + sum);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise Log',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
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
                        Icons.fitness_center,
                        color: Colors.pinkAccent,
                        size: 80,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Duration: $totalDuration minutes',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Exercises:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedExerciseIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedExerciseIndex = index;
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            exercises.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${exercises[index]['name']} removed')),
                          );
                        },
                        child: Card(
                          color: isSelected ? Colors.teal.withAlpha(51) : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: isSelected ? 6 : 2,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Icon(
                              Icons.directions_run,
                              color: isSelected ? Colors.teal : Colors.grey,
                              size: 30,
                            ),
                            title: Text(
                              exercises[index]['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.teal : Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              '${exercises[index]['duration']} minutes',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _showAddExerciseDialog,
                        child: const Text(
                          'Add New Exercise',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          _clearAllExercises();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('All exercises cleared')),
                          );
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
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
