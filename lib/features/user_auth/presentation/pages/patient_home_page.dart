import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Homepage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: pat_HomePage(),
    );
  }
}

class pat_HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<pat_HomePage> {
  // Track the index of the active page in the PageView
  int _currentIndex = 0;

  // Method to update the current page index
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDICLOUD'),
        backgroundColor: const Color.fromARGB(255, 244, 245, 246),
      ),
      body: Column(
        children: [
          // Header Section: Display user info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blueAccent,
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/profile.jpg'), // Add your profile image here
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe', // Replace with dynamic user name
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Active now', // Replace with dynamic status or last seen
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // PageView with dynamic content
          Expanded(
            child: PageView(
              onPageChanged: _onPageChanged,
              children: [
                // First Slide Page with Cards
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildCard(
                        title: 'Health Insights',
                        description: 'Get AI-powered insights about your health.',
                        backgroundImage: 'assets/health_insights.jpg',
                        onPressed: () {
                          print('Health Insights button pressed');
                        },
                      ),
                      _buildCard(
                        title: 'Recent Records',
                        description: 'View your most recent health records.',
                        backgroundImage: 'assets/recent_records.jpg',
                        onPressed: () {
                          print('Recent Records button pressed');
                        },
                      ),
                      _buildCard(
                        title: 'Diet Suggestions',
                        description: 'Receive personalized diet recommendations.',
                        backgroundImage: 'assets/diet_suggestions.jpg',
                        onPressed: () {
                          print('Diet Suggestions button pressed');
                        },
                      ),
                    ],
                  ),
                ),
                // Second Slide Page
                SlidePage(
                  backgroundColor: const Color.fromARGB(255, 107, 246, 179),
                  title: 'Logbook',
                  content: 'Track your daily health logs here!',
                ),
                // Last Slide Page - Profile View
                ProfilePage(),
              ],
            ),
          ),
          // Footer Navigation with icons
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              // Update the PageView to the selected index
              PageController().animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.volunteer_activism,
                  color: _currentIndex == 0 ? Colors.blueAccent : Colors.grey,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  color: _currentIndex == 1 ? Colors.blueAccent : Colors.grey,
                ),
                label: 'Logbook',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: _currentIndex == 2 ? Colors.blueAccent : Colors.grey,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required String backgroundImage,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // Background image
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Text content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: const Text('Explore'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlidePage extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String content;

  SlidePage({
    required this.backgroundColor,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              content,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 135, 172, 245),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 245, 245, 245),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'), // Add your profile image here
            ),
            const SizedBox(height: 20),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'johndoe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Phone: +1 234 567 8901',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
