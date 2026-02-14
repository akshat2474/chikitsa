import 'package:flutter/material.dart';
import 'package:chikitsa/screens/bson_demo_screen.dart';
import 'package:chikitsa/services/language_service.dart';
import 'package:chikitsa/screens/medical_reminders_screen.dart';
import 'package:chikitsa/screens/activity_history_screen.dart';
import 'package:chikitsa/main.dart'; // For toggleTheme

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = LanguageService.current;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                      Container(
                        width: 12,
                        height: 12,
                        color: theme.colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(lang.get('BRAND'),
                          style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5)),
                    ],
                  ),
                  Row(
                    children: [
                      // Language Toggle
                      TextButton(
                        onPressed: () {
                          LanguageService.current.toggleLanguage();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          side: BorderSide(
                              color: theme.colorScheme.onSurface, width: 2),
                        ),
                        child: Text(
                          LanguageService.current.isHindi ? 'EN' : 'हिंदी',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Theme Toggle
                      IconButton(
                        onPressed: toggleTheme,
                        icon: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ActivityHistoryScreen()),
                          );
                        },
                        icon: Icon(Icons.history,
                            color: theme.colorScheme.onSurface),
                      ),
                    ],
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
                            lang.get('HEADLINE'),
                            style: theme.textTheme.displayLarge,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            lang.get('SUBHEAD'),
                            style: theme.textTheme.bodyLarge,
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.onSurface,
                                foregroundColor: theme.colorScheme.surface,
                              ),
                              child: Text(lang.get('CTA_START')),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                        height: 1,
                        thickness: 2,
                        color: theme.colorScheme.onSurface),

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
                          lang.get('CARD_MEDS'),
                          Icons.medication_outlined,
                          () {},
                          borderRight: true,
                          borderBottom: true,
                        ),
                        _buildBrutalistCard(
                          context,
                          lang.get('CARD_REMINDERS'),
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
                          lang.get('CARD_GENERIC'),
                          Icons.currency_exchange,
                          () {},
                          borderRight: true,
                          borderBottom: false,
                        ),
                        _buildBrutalistCard(
                          context,
                          lang.get('CARD_RX'),
                          Icons.document_scanner_outlined,
                          () {},
                          borderRight: false,
                          borderBottom: false,
                        ),
                      ],
                    ),

                    Divider(
                        height: 1,
                        thickness: 2,
                        color: theme.colorScheme.onSurface),
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
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border(
            right: borderRight
                ? BorderSide(color: theme.colorScheme.onSurface, width: 2)
                : BorderSide.none,
            bottom: borderBottom
                ? BorderSide(color: theme.colorScheme.onSurface, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.onSurface),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
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
