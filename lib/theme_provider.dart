import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  Color _themeColor = Colors.pinkAccent; // Default color

  Color get themeColor => _themeColor;

  ThemeManager() {
    _loadThemeColor();
  }

  Future<void> _loadThemeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? colorString = prefs.getString('theme_color'); // Retrieve color as a hex string
    if (colorString != null) {
      _themeColor = _hexToColor(colorString);
      notifyListeners();
    }
  }

  Future<void> setThemeColor(Color color) async {
    _themeColor = color;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_color', _colorToHex(color)); // Save color as a hex string
    notifyListeners();
  }

  String _colorToHex(Color color) {
    final a = (color.a * 255).toInt().toRadixString(16).padLeft(2, '0');
    final r = (color.r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '#$a$r$g$b';
  }


  // Helper function to convert hex string to Color
  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = 'FF$hex'; // Add alpha if missing
    return Color(int.parse(hex, radix: 16)); // Create Color from hex
  }
}
