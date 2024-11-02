import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safe_space_app/privacy_settings_page.dart';
import 'about_safe_space.dart';
import 'package:safe_space_app/login_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _notificationsEnabled = false;
  bool _darkModeEnabled = false;
  String _passcode = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _loadSettings();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      _passcode = prefs.getString('user_passcode') ?? '';
    });
  }

  void _saveNotificationSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  void _saveDarkModeSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode_enabled', value);
    setState(() {
      _darkModeEnabled = value;
    });
  }

  void _handleHeartTap(Function navigateToPasswordSetting) {
    setState(() {
      _controller.forward().then((_) => _controller.reverse());
    });
  }

  Widget _buildHeart(Function navigateToPasswordSetting) {
    return GestureDetector(
      onTap: () => _handleHeartTap(navigateToPasswordSetting),
      child: ScaleTransition(
        scale: _animation,
        child: Icon(
          Icons.favorite,
          color: Colors.pink,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch() {
    return SwitchListTile(
      title: const Text('Enable Notifications'),
      value: _notificationsEnabled,
      onChanged: (bool value) {
        setState(() {
          _notificationsEnabled = value;
          _saveNotificationSetting(value);
        });
      },
    );
  }

  Widget _buildDarkModeSwitch() {
    return SwitchListTile(
      title: const Text('Enable Dark Mode'),
      value: _darkModeEnabled,
      onChanged: (bool value) {
        _saveDarkModeSetting(value);
      },
    );
  }

  Widget _buildPasscodeSetting() {
    return ListTile(
      title: const Text('Set Passcode'),
      subtitle: Text(_passcode.isNotEmpty ? 'Current Passcode: ********' : 'No Passcode Set'),
      trailing: const Icon(Icons.lock),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PasswordSettingScreen()),
        ).then((_) => _loadSettings());
      },
    );
  }

  Widget _buildPrivacySettings() {
    return ListTile(
      title: const Text('Privacy Settings'),
      trailing: const Icon(Icons.privacy_tip),
      onTap: () {
        // Navigate to privacy settings
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrivacySettingsPage()), // Navigate to your privacy settings page
        );
      },
    );
  }

  Widget _buildAboutSection() {
    return ListTile(
      title: const Text('About SafeSpace'),
      trailing: const Icon(Icons.info),
      onTap: () {
        // Navigate to AboutSafeSpace page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutSafeSpace()),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the login page when logging out
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen(title: 'Login')), // Replace with your actual login page title
              (Route<dynamic> route) => false, // This will remove all the previous routes
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text('Logout', style: TextStyle(color: Colors.white)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          _buildHeart(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PasswordSettingScreen()),
            );
          }),
        ],
      ),
      body: Container(
        color: _darkModeEnabled ? Colors.black54 : Colors.teal[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customize Your Experience',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            const SizedBox(height: 20),
            Center(
              child: _buildHeart(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PasswordSettingScreen()),
                );
              }),
            ),
            const SizedBox(height: 20),
            _buildNotificationSwitch(),
            _buildDarkModeSwitch(),
            _buildPasscodeSetting(),
            _buildPrivacySettings(), // This now navigates to the privacy settings page
            _buildAboutSection(),
            const SizedBox(height: 20),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }
}

class PasswordSettingScreen extends StatefulWidget {
  const PasswordSettingScreen({super.key});

  @override
  PasswordSettingScreenState createState() => PasswordSettingScreenState();
}

class PasswordSettingScreenState extends State<PasswordSettingScreen> {
  final TextEditingController _passcodeController = TextEditingController();

  Future<void> _savePasscode(Function showSnackBar, Function goBack) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_passcode', _passcodeController.text);
    _passcodeController.clear();
    showSnackBar('Passcode saved!');
    goBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Passcode'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        color: Colors.teal[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your new passcode', style: TextStyle(fontSize: 18, color: Colors.teal)),
            const SizedBox(height: 20),
            TextField(
              controller: _passcodeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Passcode',
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink, width: 2.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePasscode(
                        (message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))),
                        () => Navigator.pop(context),
                  );
                },
                style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.pink),
                child: const Text('Save Passcode'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
