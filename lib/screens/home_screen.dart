import 'package:flutter/material.dart';
import 'package:chikitsa/screens/bson_demo_screen.dart';
import 'package:chikitsa/screens/medical_reminders_screen.dart';
import 'package:chikitsa/screens/activity_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 12, height: 12, color: Colors.black),
                      const SizedBox(width: 8),
                      Text('CHIKITSA',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5)),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ActivityHistoryScreen()),
                      );
                    },
                    icon: const Icon(Icons.history, color: Colors.black),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Big Headline Section
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FUTURE\nOF CARE.',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'We empower progressive individuals to create lasting impact through strategic health monitoring.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 32),

                          // Primary CTA (Full width sharp button)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BsonDemoScreen()),
                                );
                              },
                              child: const Text('START ASSESSMENT'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1, thickness: 2, color: Colors.black),

                    // Feature Grid
                    // Brutalism grid: Borders between elements
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      padding: EdgeInsets.zero,
                      children: [
                        _buildBrutalistCard(
                          context,
                          'MEDICATION\nTRACKER',
                          Icons.medication_outlined,
                          () {},
                          borderRight: true,
                          borderBottom: true,
                        ),
                        _buildBrutalistCard(
                          context,
                          'SMART\nREMINDERS',
                          Icons.alarm,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MedicationRemindersScreen()),
                            );
                          },
                          borderRight: false,
                          borderBottom: true,
                        ),
                        _buildBrutalistCard(
                          context,
                          'GENERIC\nALTS',
                          Icons.currency_exchange,
                          () {},
                          borderRight: true,
                          borderBottom: false,
                        ),
                        _buildBrutalistCard(
                          context,
                          'RX\nSCANNER',
                          Icons.document_scanner_outlined,
                          () {},
                          borderRight: false,
                          borderBottom: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrutalistCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap,
      {bool borderRight = false, bool borderBottom = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border(
            right: borderRight
                ? const BorderSide(color: Colors.black, width: 2)
                : BorderSide.none,
            bottom: borderBottom
                ? const BorderSide(color: Colors.black, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 32, color: Colors.black),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
