import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/widgets/personlaized_widgets/depression_stress_management_widget.dart';
import 'package:hcq/widgets/personlaized_widgets/gastric_issues_management_widget.dart';
import 'package:hcq/widgets/personlaized_widgets/nausea_vomiting_management_widget.dart';
import 'package:hcq/widgets/personlaized_widgets/pain_management_widget.dart';
import 'package:hcq/widgets/personlaized_widgets/weakness_management_widget.dart';
import 'package:hcq/widgets/personlaized_widgets/weightloss_management_widget.dart';

class ChallengesSelectionCard extends StatelessWidget {
  const ChallengesSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primaryColor,
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Facing any challenges?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Select from below for tips & personalized care",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              // First row of icons
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconCard(
                  context,
                  "Pain",
                  Icons.healing,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PainManagementWidget(),
                    ),
                  ),
                ),
                _buildIconCard(
                  context,
                  "Weakness",
                  Icons.accessibility_new,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeaknessManagementWidget(),
                    ),
                  ),
                ),
                _buildIconCard(
                  context,
                  "Weight Loss",
                  Icons.trending_down,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeightLossManagementWidget(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0), // Add spacing between rows
            Row(
              // Second row of icons
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconCard(
                  context,
                  "Vomiting",
                  Icons.sick,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const NauseaVomitingManagementWidget(),
                    ),
                  ),
                ),
                _buildIconCard(
                  context,
                  "Depression",
                  Icons.sentiment_very_dissatisfied,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const DepressionStressManagementWidget(),
                    ),
                  ),
                ),
                _buildIconCard(
                  context,
                  "Gastric Issues",
                  Icons.local_pharmacy,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GastricIssuesManagementWidget(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconCard(BuildContext context, String title, IconData icon,
      VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              icon,
              size: 30,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
