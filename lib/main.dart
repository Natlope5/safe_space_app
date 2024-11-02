import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'setting_page.dart'; // Adjust your actual imports
import 'models/exercise_log.dart';
import 'models/resource_page.dart';
import 'models/sleep_page.dart';
import 'models/steps_page.dart';
import 'home_page.dart';
import 'login_screen.dart';
import 'mood_tracker.dart';
import 'period_tracker_page.dart';
import 'fertility_tracker.dart';
import 'water_tracking_page.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Activate App Check
  await FirebaseAppCheck.instance.activate(

  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Space App',
      theme: ThemeData(
        primaryColor: Colors.pinkAccent, // Default theme color
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pinkAccent, // Default app bar color
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(title: 'Login'),
        '/': (context) => const HomePage(),
        '/periodPage': (context) => const PeriodTrackerPage(),
        '/moodPage': (context) => const MoodTrackerPage(),
        '/fertilityPage': (context) => const FertilityTrackerPage(),
        '/settingsPage': (context) => const SettingsPage(),
        '/sleepPage': (context) => const SleepPage(),
        '/exerciseLogPage': (context) => const ExerciseLogPage(),
        '/stepsPage': (context) => const StepsPage(),
        '/hydrationPage': (context) => const WaterTrackerPage(),
        '/resourcesPage': (context) => const ResourcesPage(),
      },
    );
  }
}

// Helper function to parse colors safely
Color parseColorFromString(String colorString) {
  try {
    List<String> colorComponents = colorString.split(',');
    double red = double.parse(colorComponents[0]) * 255;
    double green = double.parse(colorComponents[1]) * 255;
    double blue = double.parse(colorComponents[2]) * 255;
    return Color.fromRGBO(red.toInt(), green.toInt(), blue.toInt(), 1.0);
  } catch (e) {
    final Logger logger = Logger();
    logger.e('Error parsing color: $e');
    return Colors.grey; // Default color in case of an error
  }
}
