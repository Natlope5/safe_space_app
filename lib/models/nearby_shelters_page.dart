import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class NearbySheltersPage extends StatefulWidget {
  final String zipCode;

  const NearbySheltersPage({super.key, required this.zipCode});

  @override
  NearbySheltersPageState createState() => NearbySheltersPageState();
}

class NearbySheltersPageState extends State<NearbySheltersPage> {
  final String apiKey = 'e57c9ecf4dmsh3613c1b61292fc4p17de88jsneb86e5df5e98';
  List<Map<String, dynamic>> shelters = [];
  bool isLoading = true;
  String? errorMessage;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchShelters();
  }

  Future<void> _fetchShelters() async {
    final url = Uri.parse('https://topapis.com/homeless-shelter-api/search?zip=${widget.zipCode}');
    logger.d("Fetching shelters from URL: $url");

    try {
      final response = await http.get(url, headers: {'Authorization': 'Bearer $apiKey'});
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        logger.d("Shelter data: $data");

        if (mounted) {
          setState(() {
            shelters = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load shelters: ${response.statusCode}');
      }
    } catch (error) {
      logger.e('Error fetching shelters: $error');
      setState(() {
        errorMessage = 'Could not load shelter data';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Shelters')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : shelters.isEmpty
          ? const Center(child: Text('No shelters found'))
          : ListView.builder(
        itemCount: shelters.length,
        itemBuilder: (context, index) {
          final shelter = shelters[index];
          return ListTile(
            title: Text(shelter['name'] ?? 'No name'),
            subtitle: Text(shelter['address'] ?? 'No address'),
            onTap: () => _showShelterDetails(shelter),
          );
        },
      ),
    );
  }

  void _showShelterDetails(Map<String, dynamic> shelter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(shelter['name'] ?? 'Shelter Details'),
          content: Text(shelter['description'] ?? 'No description available'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
