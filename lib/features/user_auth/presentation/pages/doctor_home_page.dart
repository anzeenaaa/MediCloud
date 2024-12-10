import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DoctorHomePage(),
    );
  }
}

class DoctorHomePage extends StatefulWidget {
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  // Sample list of recent patients
  final List<Map<String, String>> _recentPatients = [
    {"name": "John Doe", "id": "P001"},
    {"name": "Jane Smith", "id": "P002"},
    {"name": "Michael Johnson", "id": "P003"},
    {"name": "Emily Davis", "id": "P004"},
  ];

  // Search query to filter patients
  String _searchQuery = '';

  // Profile info
  String _doctorName = 'Dr. Sarah Lee';
  String _specialization = 'Cardiologist';
  String _email = 'sarah.lee@example.com';

  // Controller for the search bar
  TextEditingController _searchController = TextEditingController();

  // Show profile details
  void _showProfileDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name: $_doctorName'),
            Text('Specialization: $_specialization'),
            Text('Email: $_email'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Logout action (close the dialog)
              Navigator.pop(context);
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Filter patients based on the search query
  List<Map<String, String>> _getFilteredPatients() {
    if (_searchQuery.isEmpty) {
      return _recentPatients;
    } else {
      return _recentPatients
          .where((patient) =>
              patient['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              patient['id']!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: _showProfileDetails,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Patients',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Recent Consulted Patients List
            Text(
              'Recent Consulted Patients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Patients List (Table View)
            Expanded(
              child: ListView(
                children: _getFilteredPatients().map((patient) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(patient['name']!),
                      subtitle: Text('ID: ${patient['id']}'),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
