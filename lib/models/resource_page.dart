import 'package:flutter/material.dart';
import 'nearby_shelters_page.dart'; // Ensure this import is correct
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<Position?> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  void _navigateToNearbyShelters() async {
    Position? position = await _getLocation();
    if (mounted) {
      if (position != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NearbySheltersPage( zipCode: '',)),
        );
      } else {
        _showErrorDialog('Unable to access location. Please check your settings.');
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showErrorDialog('Could not make the call. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFC1E3), Color(0xFF008080)], // Pink and Teal gradient
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildResourceTile(
                      icon: Icons.local_hospital,
                      label: 'Nearby Shelters',
                      color: Colors.teal,
                      onTap: _navigateToNearbyShelters,
                    ),
                    _buildResourceTile(
                      icon: Icons.phone,
                      label: 'Suicide Hotline',
                      color: Colors.pinkAccent,
                      onTap: () => _makePhoneCall('988'),
                    ),
                    _buildResourceTile(
                      icon: Icons.security,
                      label: 'Domestic Violence Hotline',
                      color: Colors.teal,
                      onTap: () => _makePhoneCall('8007997233'),
                    ),
                    _buildResourceTile(
                      icon: Icons.restaurant,
                      label: 'Food Pantry Nearby',
                      color: Colors.pinkAccent,
                      onTap: () {
                        // Add food pantry location action
                      },
                    ),
                    _buildResourceTile(
                      icon: Icons.phone_in_talk,
                      label: 'Call Emergency Services',
                      color: Colors.teal,
                      onTap: () => _makePhoneCall('911'),
                    ),
                    _buildResourceTile(
                      icon: Icons.textsms,
                      label: 'Text Emergency Services',
                      color: Colors.pinkAccent,
                      onTap: () {
                        // Add emergency services text functionality
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.pinkAccent,
        child: const Text(
          'Kill',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildResourceTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      onEnter: (_) => _animationController.forward(),
      onExit: (_) => _animationController.reverse(),
      child: ScaleTransition(
        scale: _animation,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: color),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
