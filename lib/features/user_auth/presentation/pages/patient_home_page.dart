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

  // Show a dialog box
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
                // First Slide Page with Dialog Buttons
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _showDialog(
                          'Health Insights',
                          'Here are your latest health insights.',
                        ),
                        child: const Text('Health Insights'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _showDialog(
                          'Recent Records',
                          'These are your recent health records.',
                        ),
                        child: const Text('Recent Records'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _showDialog(
                          'Diet Suggestions',
                          'These are your personalized diet suggestions.',
                        ),
                        child: const Text('Diet Suggestions'),
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