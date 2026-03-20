import 'package:chikitsa/services/language_service.dart';
import 'package:flutter/material.dart';

class GenericAltsScreen extends StatefulWidget {
  const GenericAltsScreen({super.key});

  @override
  State<GenericAltsScreen> createState() => _GenericAltsScreenState();
}

class _GenericAltsScreenState extends State<GenericAltsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final lang = LanguageService.current;
    final theme = Theme.of(context);

    // Dummy data for Augmentin result
    final bool showAugmentin = _searchQuery.toLowerCase().contains('aug');

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.get('GENERIC_TITLE')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: lang.get('GENERIC_SEARCH_HINT'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = "";
                          });
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_searchQuery.isEmpty) ...[
                  // Recent Searches Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      lang.get('GENERIC_RECENT'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  _buildComparisonCard(
                    context,
                    brandName: 'Pan-D',
                    genericName: 'Pantoprazole + Domperidone',
                    brandPrice: 199,
                    genericPrice: 45,
                    dosage: '10 Capsules',
                  ),
                  _buildComparisonCard(
                    context,
                    brandName: 'Shelcal 500',
                    genericName: 'Calcium + Vitamin D3',
                    brandPrice: 140,
                    genericPrice: 60,
                    dosage: '15 Tablets',
                  ),
                  _buildComparisonCard(
                    context,
                    brandName: 'Dolo 650',
                    genericName: 'Paracetamol 650mg',
                    brandPrice: 35,
                    genericPrice: 12,
                    dosage: '15 Tablets',
                  ),
                ] else if (showAugmentin) ...[
                  // Search Result
                  _buildComparisonCard(
                    context,
                    brandName: 'Augmentin 625',
                    genericName: 'Amoxicillin + Clavulanate',
                    brandPrice: 223,
                    genericPrice: 85,
                    dosage: '6 Tablets',
                  ),
                ] else ...[
                  // No results
                  const SizedBox(height: 48),
                  const Center(
                    child: Text(
                      'No alternatives found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(
    BuildContext context, {
    required String brandName,
    required String genericName,
    required double brandPrice,
    required double genericPrice,
    required String dosage,
  }) {
    final theme = Theme.of(context);
    final lang = LanguageService.current;

    final savings = brandPrice - genericPrice;
    final savingsPercent = (savings / brandPrice * 100).round();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // Header with Savings
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.savings, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${lang.get('GENERIC_SAVE')} $savingsPercent%',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  dosage,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Branded Side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.get('GENERIC_BRAND'),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        brandName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${brandPrice.toInt()}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),

                // VS Divider
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                // Generic Side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        lang.get('GENERIC_ALT'),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        genericName,
                        textAlign: TextAlign.end,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${genericPrice.toInt()}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
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
