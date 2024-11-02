import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  PrivacySettingsPageState createState() => PrivacySettingsPageState();
}

class PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _locationSharingEnabled = false;
  bool _dataCollectionEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  void _loadPrivacySettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationSharingEnabled = prefs.getBool('location_sharing_enabled') ?? false;
      _dataCollectionEnabled = prefs.getBool('data_collection_enabled') ?? false;
    });
  }

  void _savePrivacySetting(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    setState(() {
      if (key == 'location_sharing_enabled') {
        _locationSharingEnabled = value;
      } else if (key == 'data_collection_enabled') {
        _dataCollectionEnabled = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        color: Colors.teal[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Enable Location Sharing'),
              value: _locationSharingEnabled,
              onChanged: (bool value) {
                _savePrivacySetting('location_sharing_enabled', value);
              },
            ),
            SwitchListTile(
              title: const Text('Enable Data Collection'),
              value: _dataCollectionEnabled,
              onChanged: (bool value) {
                _savePrivacySetting('data_collection_enabled', value);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
