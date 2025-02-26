import 'package:flutter/material.dart';
import 'watch.dart';
import 'profile.dart';
import 'search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class StressLabel extends StatelessWidget {
  final String label;
  final String range;

  const StressLabel({super.key, required this.label, required this.range});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          range,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> tasks = [];
  final List<String> moods = [
    'Happy',
    'Fearful',
    'Excited',
    'Angry',
    'Calm',
    'Pain',
    'Boredom',
    'Sad',
    'Awe',
    'Confused',
    'Anxious',
    'Relief',
    'Satisfied'
  ];
  final Set<String> selectedMoods = {};
  double stressLevel = 3;
  final Map<String, bool> symptoms = {
    'Rapid heartbeat': false,
    'Shortness of breath': false,
    'Dizziness': false,
    'Headache': false,
    'Fatigue': false,
    'Sweating': false,
    'Muscle tension': false,
    'Nausea': false,
    'Shaking or trembling': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hello Message
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: const [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Hello Mejia!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Meditation Card and Action Icons Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meditation Card
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 150,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'meditation',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'take a break',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '(5 min)',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Action Icons Grid
                  Expanded(
                    flex: 3,
                    child: GridView.count(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevents independent scrolling
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio:
                          1.8, // Adjust aspect ratio for better spacing
                      children: [
                        _buildActionIcon(Icons.watch_outlined, 'Watch', context,
                            WatchScreen()),
                        _buildActionIcon(Icons.navigation, 'Navigation',
                            context, SearchScreen()),
                        _buildActionIcon(Icons.person_outline, 'Profile',
                            context, const ProfilePage()),
                        _buildActionIcon(Icons.calendar_today, 'Calendar',
                            context, null, _showDateTimePicker),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Connection Status
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Connected'),
                    Row(
                      children: [
                        BatteryIndicator(
                          batteryLevel: 0.75, // Example battery level
                        ),
                        const SizedBox(width: 8),
                        const Text('75%'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Express Your Feelings Text
              const Center(
                child: Text(
                  'Express Your Feelings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Sheet Items
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _buildBottomSheetItem(
                      context,
                      'Mood Tracker',
                      Icons.mood,
                      Colors.blue,
                      _showMoodTracker,
                    ),
                    _buildBottomSheetItem(
                      context,
                      'Stress Level Rating',
                      Icons.sentiment_very_dissatisfied,
                      Colors.red,
                      _showStressTracker,
                    ),
                    _buildBottomSheetItem(
                      context,
                      'Physical Symptoms',
                      Icons.healing,
                      Colors.green,
                      _showPhysicalSymptomsTracker,
                    ),
                    _buildBottomSheetItem(
                      context,
                      'Activities Tracker',
                      Icons.directions_run,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon(
      IconData icon, String label, BuildContext context, Widget? page,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green[600], size: 24),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(color: Colors.green[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showDateTimePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {});
      }
    });
  }

  void _showMoodTracker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Mood Tracker',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: moods.map((mood) {
                      return ChoiceChip(
                        label: Text(mood),
                        selected: selectedMoods.contains(mood),
                        selectedColor: Colors.green,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedMoods.add(mood);
                            } else {
                              selectedMoods.remove(mood);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showStressTracker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Stress Tracker',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          StressLabel(label: 'Extreme Stress', range: '9-10'),
                          StressLabel(label: 'High Stress', range: '7-8'),
                          StressLabel(label: 'Moderate Stress', range: '4-6'),
                          StressLabel(label: 'Low Stress', range: '3-4'),
                          StressLabel(label: 'StressLess', range: '<3'),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Container(
                        height: 300,
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Slider(
                            value: stressLevel,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            activeColor: Colors.orange,
                            onChanged: (double value) {
                              setState(() {
                                stressLevel = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.sentiment_very_dissatisfied,
                              color: Colors.purple, size: 40),
                          Icon(Icons.sentiment_dissatisfied,
                              color: Colors.red, size: 40),
                          Icon(Icons.sentiment_neutral,
                              color: Colors.brown, size: 40),
                          Icon(Icons.sentiment_satisfied,
                              color: Colors.amber, size: 40),
                          Icon(Icons.sentiment_very_satisfied,
                              color: Colors.green, size: 40),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPhysicalSymptomsTracker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Physical Symptoms',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...symptoms.keys.map((symptom) => CheckboxListTile(
                        title: Text(symptom),
                        value: symptoms[symptom],
                        onChanged: (bool? value) {
                          setState(() {
                            symptoms[symptom] = value!;
                          });
                        },
                        secondary: const Icon(Icons.local_hospital),
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomSheetItem(
      BuildContext context, String title, IconData icon, Color color,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class BatteryIndicator extends StatelessWidget {
  final double batteryLevel;

  const BatteryIndicator({super.key, required this.batteryLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Stack(
        children: [
          Container(
            width: batteryLevel * 36,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: batteryLevel > 0.2 ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          Positioned(
            right: 2,
            top: 5,
            bottom: 5,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
