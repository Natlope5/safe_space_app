import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  MoodTrackerPageState createState() => MoodTrackerPageState();
}

class MoodTrackerPageState extends State<MoodTrackerPage> {
  String? selectedMood;
  final List<String> moods = [
    "😊 Happy",
    "😢 Sad",
    "😠 Angry",
    "😴 Tired",
    "😐 Neutral"
  ];
  List<String> notes = []; // To store notes
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Load notes from Shared Preferences
  }

  @override
  void dispose() {
    _noteController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = prefs.getStringList('notes') ?? []; // Load saved notes
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'notes', notes); // Save notes to Shared Preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Tracker"),
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView( // Make the whole body scrollable
        child: Container(
          width: double.infinity, // Fills entire width
          padding: const EdgeInsets.all(16.0), // Add padding for spacing
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF48FB1), Color(0xFFF06292), Color(0xFFEC407A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align to the start
            children: [
              const SizedBox(height: 30),
              _buildMoodCard(),
              const SizedBox(height: 20),
              _buildMoodSelector(),
              const SizedBox(height: 20),
              _buildMoodLog(),
              const SizedBox(height: 20),
              _buildPostItBoard(),
              // Pegboard here
              const SizedBox(height: 20),
              _buildNoteInputField(),
              // Added input field for notes below the board
            ].animate().fadeIn(duration: 800.ms).slide(
                begin: const Offset(0, 0.3)),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(179),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Today's Mood",
            style: TextStyle(
              color: Color(0xFFD81B60),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: selectedMood != null ? 80 : 60,
            // Change size based on mood selection
            width: selectedMood != null ? 80 : 60,
            // Change size based on mood selection
            child: Icon(
              selectedMood == "😊 Happy"
                  ? Icons.sentiment_satisfied
                  : selectedMood == "😢 Sad"
                  ? Icons.sentiment_dissatisfied
                  : selectedMood == "😠 Angry"
                  ? Icons.sentiment_very_dissatisfied
                  : selectedMood == "😴 Tired"
                  ? Icons.sentiment_neutral
                  : Icons.sentiment_neutral, // Default icon for Neutral
              size: 60,
              color: selectedMood != null
                  ? const Color(0xFFD81B60) // Change color if mood is selected
                  : Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedMood ?? "No mood selected",
            style: const TextStyle(color: Colors.black87,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(179),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Select Your Mood",
            style: TextStyle(
              color: Color(0xFFD81B60),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: moods.map((mood) {
              return ChoiceChip(
                label: Text(
                  mood,
                  style: const TextStyle(color: Colors.black),
                ),
                selected: selectedMood == mood,
                selectedColor: const Color(0xFFF06292).withAlpha(77),
                onSelected: (bool selected) {
                  setState(() {
                    selectedMood = selected ? mood : null;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodLog() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(179),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // Center the children horizontally
        children: [
          const Text(
            "Mood Log",
            style: TextStyle(
              color: Color(0xFFD81B60),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedMood != null
                ? "Most recent mood: $selectedMood"
                : "No mood logged yet.",
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ),
    );
  }


  Widget _buildPostItBoard() {
    return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        // Make the pegboard take the full width
        height: 300,
        // Increased height for the pegboard
        decoration: BoxDecoration(
          color: const Color(0xFF8B5A2B), // Brown color for the pegboard
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black54, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(38),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // Align children at the top
          crossAxisAlignment: CrossAxisAlignment.center,
          // Center the children horizontally
          children: [
            const Text(
              "Notes Post-It Board",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Display notes as clickable items
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _buildNotesList(),
            ),
          ],
        ));
  }


  Widget _buildNoteInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: "Add a note...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNote,
          ),
        ],
      ),
    );
  }

  void _addNote() {
    final noteText = _noteController.text.trim();
    if (noteText.isNotEmpty) {
      setState(() {
        notes.add(noteText);
        _saveNotes(); // Save notes after adding
        _noteController.clear(); // Clear input field
      });
    }
  }

  List<Widget> _buildNotesList() {
    return notes.map((note) {
      return GestureDetector(
        onTap: () => _showNoteDialog(note), // Show dialog when note is tapped
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
              decoration: BoxDecoration(
                color: Colors.pink[100],
                // Light pink background
                borderRadius: BorderRadius.circular(8),
                // Slightly round corners
                border: Border.all(
                    color: Colors.black54), // Optional border for definition
              ),
              child: Center(
                child: Text(
                  note,
                  textAlign: TextAlign.center, // Center text horizontally
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
            Positioned(
              top: -10,
              left: (120 / 2) - (20 / 2) - 15,
              child: IconButton(
                icon: const Icon(
                    Icons.push_pin, color: Colors.pinkAccent, size: 20),
                onPressed: () {
                  setState(() {
                    notes.remove(note);
                    _saveNotes(); // Save notes after deletion
                  });
                },
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _showNoteDialog(String note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFE6E6),
          // Light pink background color
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Note Details',
                style: TextStyle(color: Colors.pinkAccent), // Title text color
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.pinkAccent),
                // Pink pencil icon
                onPressed: () {
                  Navigator.of(context).pop(); // Close the current dialog
                  _editNoteDialog(note); // Open the edit dialog
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  note,
                  style: const TextStyle(fontSize: 16,
                      color: Colors.black87), // Font color for readability
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(
                    color: Colors.pinkAccent), // Button text color in pink
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

// This function shows a dialog where the user can edit the note
  void _editNoteDialog(String currentNote) {
    TextEditingController controller = TextEditingController(
        text: currentNote);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter your updated note here',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                  'Save', style: TextStyle(color: Colors.pinkAccent)),
              onPressed: () {
                String updatedNote = controller.text;
                Navigator.of(context).pop(); // Close the edit dialog
                _showNoteDialog(updatedNote); // Show the updated note
              },
            ),
          ],
        );
      },
    );
  }
}