import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedPeriod = 'Daily';

  List<FlSpot> _getSpots() {
    switch (_selectedPeriod) {
      case 'Weekly':
        return [
          FlSpot(1, 2),
          FlSpot(2, 4),
          FlSpot(3, 1),
          FlSpot(4, 3),
          FlSpot(5, 5),
          FlSpot(6, 2),
          FlSpot(7, 4),
        ];
      case 'Monthly':
        return [
          FlSpot(1, 3),
          FlSpot(2, 2),
          FlSpot(3, 5),
          FlSpot(4, 1),
          FlSpot(5, 4),
          FlSpot(6, 3),
          FlSpot(7, 2),
          FlSpot(8, 5),
          FlSpot(9, 1),
          FlSpot(10, 4),
          FlSpot(11, 3),
          FlSpot(12, 2),
        ];
      case 'Daily':
      default:
        return [
          FlSpot(1, 1),
          FlSpot(2, 3),
          FlSpot(3, 2),
          FlSpot(4, 5),
          FlSpot(5, 3),
          FlSpot(6, 4),
        ];
    }
  }

  Widget _buildTimeButton(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = text;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade700 : Colors.green.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: SingleChildScrollView( // Prevents overflow
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to top
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(radius: 16, backgroundColor: Colors.grey),
                      SizedBox(width: 12),
                      Text(
                        'Hello Mejia!',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildTimeButton('Daily', _selectedPeriod == 'Daily'),
                    const SizedBox(width: 8),
                    _buildTimeButton('Weekly', _selectedPeriod == 'Weekly'),
                    const SizedBox(width: 8),
                    _buildTimeButton('Monthly', _selectedPeriod == 'Monthly'),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitles: (value) {
                            switch (_selectedPeriod) {
                              case 'Weekly':
                                return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][value.toInt() - 1];
                              case 'Monthly':
                                return ['Week 1', 'Week 2', 'Week 3', 'Week 4'][value.toInt() - 1];
                              case 'Daily':
                              default:
                                return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'][value.toInt() - 1];
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitles: (value) => value.toString(),
                        ),
                        topTitles: SideTitles(showTitles: false),
                        rightTitles: SideTitles(showTitles: false),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: const Color(0xff37434d)),
                      ),
                      minX: 0,
                      maxX: _selectedPeriod == 'Monthly' ? 12 : 7,
                      minY: 0,
                      maxY: 6,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _getSpots(),
                          isCurved: true,
                          colors: [Colors.blue.shade800],
                          barWidth: 5,
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
