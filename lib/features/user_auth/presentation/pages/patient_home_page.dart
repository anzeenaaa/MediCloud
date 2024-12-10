import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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

  // Method to pick a file (Medical or Scan Reports)
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'], // Allow PDF and image files
    );
    if (result != null) {
      print('File selected: ${result.files.single.name}');
    } else {
      print('File selection canceled.');
    }
  }

  // Controller for the symptom text box
  TextEditingController _symptomController = TextEditingController();

  // Method to append common symptoms to the text box
  void _addSymptom(String symptom) {
    setState(() {
      _symptomController.text += symptom + ', ';
    });
  }

  // Widget to display a symptom with an icon
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEDICLOUD'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        children: [
          // Header Section: Display user info
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color.fromARGB(255, 250, 250, 251),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/avatar.jpg'), // Add your profile image here
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe', // Replace with dynamic user name
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Active now', // Replace with dynamic status or last seen
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
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
                Container(
                  color: const Color.fromARGB(255, 253, 253, 253), // Set your desired background color here
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildCard(
                          title: 'Health Insights',
                          description: 'Get AI-powered insights about your health.',
                          backgroundImage: 'assets/insight.jpg',
                          onPressed: () {
                            print('Health Insights button pressed');
                          },
                        ),
                        _buildCard(
                          title: 'Recent Records',
                          description: 'View your most recent health records.',
                          backgroundImage: 'assets/recent.jpg',
                          onPressed: () {
                            print('Recent Records button pressed');
                          },
                        ),
                        _buildCard(
                          title: 'Diet Suggestions',
                          description: 'Receive personalized diet recommendations.',
                          backgroundImage: 'assets/diet.jpg',
                          onPressed: () {
                            print('Diet Suggestions button pressed');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Second Slide Page with Symptom Logging and File Uploads
                Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Section
                        const Text(
                          'Logbook',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Text Box for Symptoms
                        const Text(
                          'Enter Your Symptoms',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Modern style text box for symptoms
                        TextField(
                          controller: _symptomController,
                          decoration: InputDecoration(
                            hintText: 'Describe your symptoms...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),

                        // Common Symptoms Buttons
                        const Text(
                          'Common Symptoms',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => _addSymptom('Cough'),
                              child: const Text('Cough'),
                            ),
                            ElevatedButton(
                              onPressed: () => _addSymptom('Cold'),
                              child: const Text('Cold'),
                            ),
                            ElevatedButton(
                              onPressed: () => _addSymptom('Headache'),
                              child: const Text('Headache'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Medical Reports Upload Section
                        const Text(
                          'Upload Medical Reports',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _pickFile, // File picker function for medical reports
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Choose File'),
                        ),
                        const SizedBox(height: 20),

                        // Scan Reports Upload Section
                        const Text(
                          'Upload Scan Reports',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _pickFile, // File picker function for scan reports
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Choose File'),
                        ),
                      ],
                    ),
                  ),
                ),
                // Profile Page Placeholder
               // Profile Page
Container(
  color: const Color.fromARGB(255, 250, 250, 251),
  child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Profile Picture
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/profile.jpg'), // Replace with actual profile image
        ),
        const SizedBox(height: 20),

        // Name
        const Text(
          'John Doe', // Replace with dynamic name
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),

        // Email
        const Text(
          'johndoe@example.com', // Replace with dynamic email
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),

        // Phone Number
        const Text(
          'Phone: +1 234 567 8901', // Replace with dynamic phone number
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 20),

        // Edit Profile Button
        ElevatedButton(
          onPressed: () {
            // Add functionality to edit profile here
            print('Edit Profile button pressed');
          },
          child: const Text('Edit Profile'),
        ),
      ],
    ),
  ),
),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
