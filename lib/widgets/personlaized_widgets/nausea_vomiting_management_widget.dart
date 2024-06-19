import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/widgets/tip_card.dart';

class NauseaVomitingManagementWidget extends StatelessWidget {
  const NauseaVomitingManagementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('Nausea and Vomiting Management Tips'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TipCard(
            title: "Dietary Tips",
            tips: const [
              "Eat small, frequent meals: Avoid large meals and opt for smaller portions throughout the day.",
              "Choose bland foods: Stick to easily digestible foods such as crackers, toast, bananas, and rice.",
              "Stay hydrated: Sip clear fluids like water, herbal tea, or electrolyte drinks to prevent dehydration.",
            ],
          ),
          TipCard(
            title: "Food and Drink Choices",
            tips: const [
              "Avoid trigger foods: Steer clear of spicy, greasy, or strong-smelling foods that may exacerbate nausea.",
              "Cold foods: Cold or room-temperature foods may be better tolerated than hot meals.",
              "Ginger: Try ginger tea, ginger ale, or ginger candies, known for their anti-nausea properties.",
            ],
          ),
          TipCard(
            title: "Behavioral Strategies",
            tips: const [
              "Rest after eating: Avoid lying down immediately after eating to reduce the risk of nausea.",
              "Fresh air: Open windows or step outside for fresh air if feeling nauseous.",
              "Relaxation techniques: Practice deep breathing or meditation to alleviate stress-related nausea.",
            ],
          ),
          TipCard(
            title: "Medications",
            tips: const [
              "Over-the-counter options: Consider medications like antihistamines or anti-nausea drugs under medical guidance.",
              "Prescription medications: Consult with healthcare providers for stronger medications if needed.",
              "Supplements: Explore options like vitamin B6 or ginger supplements, known to ease nausea.",
            ],
          ),
          TipCard(
            title: "Hygiene and Comfort",
            tips: const [
              "Oral hygiene: Brush teeth or use mouthwash after vomiting to freshen breath and reduce discomfort.",
              "Cool cloths: Apply cool cloths to the forehead or back of the neck to ease discomfort.",
              "Comfortable clothing: Wear loose-fitting clothing to avoid unnecessary pressure on the abdomen.",
            ],
          ),
        ],
      ),
    );
  }
}
