import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/widgets/tip_card.dart';

class WeightLossManagementWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: Text('Weight Loss Management Tips'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TipCard(
            title: "Nutrition",
            tips: const [
              "Eat a balanced diet: Include plenty of fruits, vegetables, lean proteins, and whole grains.",
              "Portion control: Monitor portion sizes to avoid overeating.",
              "Stay hydrated: Drink water throughout the day to support metabolism and reduce appetite.",
            ],
          ),
          TipCard(
            title: "Physical Activity",
            tips: const [
              "Regular exercise: Engage in aerobic activities like walking, jogging, or swimming for at least 30 minutes most days of the week.",
              "Strength training: Incorporate resistance exercises to build muscle and boost metabolism.",
              "Flexibility exercises: Include stretching to improve mobility and prevent injuries during exercise.",
            ],
          ),
          TipCard(
            title: "Behavioral Changes",
            tips: const [
              "Set realistic goals: Establish achievable weight loss goals and track progress.",
              "Monitor food intake: Keep a food diary to track calories and identify eating habits.",
              "Manage stress: Practice relaxation techniques like deep breathing or meditation to reduce stress eating.",
            ],
          ),
          TipCard(
            title: "Medical Support",
            tips: const [
              "Consult healthcare provider: Discuss weight loss goals and potential barriers with a healthcare professional.",
              "Medication or supplements: Consider medications or supplements recommended by healthcare providers if necessary.",
              "Behavioral therapy: Seek support from a therapist or counselor specializing in weight management.",
            ],
          ),
          TipCard(
            title: "Lifestyle Changes",
            tips: const [
              "Sleep hygiene: Prioritize adequate sleep to support weight loss efforts and overall health.",
              "Limit alcohol intake: Reduce or eliminate alcohol consumption to minimize empty calories.",
              "Avoid fad diets: Focus on sustainable lifestyle changes rather than quick-fix diets.",
            ],
          ),
        ],
      ),
    );
  }
}
