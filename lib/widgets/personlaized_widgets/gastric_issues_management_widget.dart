import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/widgets/tip_card.dart';

class GastricIssuesManagementWidget extends StatelessWidget {
  const GastricIssuesManagementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('Gastric Issues Management Tips'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          TipCard(
            title: "Dietary Recommendations",
            tips: [
              "Eat smaller meals: Opt for frequent, smaller meals throughout the day instead of large meals.",
              "Avoid trigger foods: Identify and avoid foods that worsen gastric issues, such as spicy, fatty, or acidic foods.",
              "Increase fiber intake: Incorporate fiber-rich foods like fruits, vegetables, and whole grains to promote digestive health.",
            ],
          ),
          TipCard(
            title: "Hydration and Fluid Intake",
            tips: [
              "Drink plenty of water: Stay hydrated by drinking water throughout the day.",
              "Avoid carbonated beverages: Limit consumption of carbonated drinks that may contribute to gas and bloating.",
              "Herbal teas: Consider drinking herbal teas like peppermint or chamomile to soothe digestion.",
            ],
          ),
          TipCard(
            title: "Lifestyle Adjustments",
            tips: [
              "Manage stress: Practice stress-reduction techniques such as deep breathing or meditation.",
              "Exercise regularly: Engage in moderate physical activity to promote healthy digestion.",
              "Quit smoking: If applicable, quit smoking as it can exacerbate gastric issues.",
            ],
          ),
          TipCard(
            title: "Medication and Supplements",
            tips: [
              "Antacids: Consider over-the-counter antacids for relief from heartburn or acid reflux symptoms.",
              "Probiotics: Discuss with healthcare providers about adding probiotic supplements to promote gut health.",
              "Prescription medications: Consult with doctors for medications that target specific gastric issues like GERD or ulcers.",
            ],
          ),
          TipCard(
            title: "Medical Evaluation and Monitoring",
            tips: [
              "Consult healthcare providers: Seek medical advice for persistent or severe gastric symptoms.",
              "Follow-up appointments: Attend regular follow-ups to monitor progress and adjust treatment plans if necessary.",
              "Keep a symptom journal: Track symptoms and triggers to better manage and communicate with healthcare providers.",
            ],
          ),
        ],
      ),
    );
  }
}
