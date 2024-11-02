import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _isHeartRed = false;
  late AnimationController _heartController;
  int _clickCountToShowDialog = 0; // More descriptive variable name
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.8,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          ScaleTransition(
            scale: _heartController,
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: _isHeartRed ? Colors.teal : Colors.white,
              ),
              onPressed: _handleHeartClick,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(
                  context, '/settingsPage'); // Navigate to settings page
            },
          ),
        ],
        backgroundColor: Colors.pinkAccent,
        elevation: 5.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFC1E3), // Light Pink
              Color(0xFF008080), // Teal
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 220,
                child: PageView(
                  children: [
                    _buildStatCard(
                        'Steps Today',
                        '5,432',
                        Icons.directions_walk,
                        '/stepsPage'
                    ),
                    _buildStatCard(
                        'Water Intake',
                        '1.5L',
                        Icons.local_drink,
                        '/hydrationPage'
                    ),
                    _buildStatCard(
                        'Calories Burned',
                        '220',
                        Icons.local_fire_department,
                        '/caloriesPage'
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTrackerCard(
                      'Period Tracker',
                      Icons.calendar_today,
                      '/periodPage'
                  ),
                  const SizedBox(width: 20),
                  _buildTrackerCard(
                      'Mood Tracker',
                      Icons.mood,
                      '/moodPage'
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTrackerCard(
                      'Fertility Window',
                      Icons.pregnant_woman,
                      '/fertilityPage'
                  ),
                  const SizedBox(width: 20),
                  _buildTrackerCard(
                      'Hydration Tracker',
                      Icons.local_drink,
                      '/hydrationPage'
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildAdditionalInfoSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Build a card for displaying statistics
  Widget _buildStatCard(String title, String stat, IconData icon,
      String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: SizedBox(
        height: 160,
        child: Card(
          color: Colors.white.withAlpha(204),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.pinkAccent),
                const SizedBox(height: 10),
                Text(stat, style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(title, style: const TextStyle(
                    fontSize: 16, color: Colors.black54)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build a card for tracking features
  Widget _buildTrackerCard(String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 128, 128, 0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Build additional information section
  Widget _buildAdditionalInfoSection() {
    return Column(
      children: [
        _buildInfoCard(
            'Sleep Tracker', 'Track your sleep patterns for better health.',
            '/sleepPage'),
        _buildInfoCard('Exercise Log',
            'Keep a record of your daily exercises and stay fit!',
            '/exerciseLogPage'),
      ],
    );
  }

  // Build an info card
  Widget _buildInfoCard(String title, String description, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        color: Colors.white.withAlpha(204),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
              title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(description),
          leading: const Icon(Icons.info, color: Colors.teal),
        ),
      ),
    );
  }

  // Handle heart icon clicks
  void _handleHeartClick() {
    setState(() {
      _isHeartRed = !_isHeartRed;

      if (_isHeartRed) {
        _heartController.forward();
      } else {
        _heartController.reverse();
      }

      _clickCountToShowDialog++;
      if (_clickCountToShowDialog == 5) {
        _showPasswordDialog(); // Show password dialog on fifth click
      }
    });
  }

// Show a password input dialog when the heart is clicked five times
  void _showPasswordDialog() {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your password to continue.'),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (passwordController.text == '1685') { // Correct password
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, '/resourcesPage'); // Navigate to resources page
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect password!')),
                );
              }
            },
            child: const Text('Submit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    ).then((_) {
      // Reset the click counter after the dialog is closed
      _clickCountToShowDialog = 0;
    });
  }
  }