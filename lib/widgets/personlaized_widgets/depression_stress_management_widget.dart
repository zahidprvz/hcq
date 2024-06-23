import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/widgets/tip_card.dart';

class DepressionStressManagementWidget extends StatelessWidget {
  const DepressionStressManagementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('Depression and Stress Management Tips'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          TipCard(
            title: "Self-Care Practices",
            tips: [
              "Establish a routine: Maintain regular sleep, meal, and activity schedules.",
              "Exercise regularly: Engage in physical activities like walking, yoga, or dancing to boost mood.",
              "Practice relaxation techniques: Incorporate deep breathing, meditation, or progressive muscle relaxation into your daily routine.",
            ],
          ),
          TipCard(
            title: "Social Support",
            tips: [
              "Stay connected: Maintain relationships with friends, family, or support groups.",
              "Seek emotional support: Talk to trusted individuals about your feelings and experiences.",
              "Join a support group: Participate in groups or communities that understand your challenges.",
            ],
          ),
          TipCard(
            title: "Healthy Lifestyle Choices",
            tips: [
              "Eat well-balanced meals: Consume a diet rich in fruits, vegetables, lean proteins, and whole grains.",
              "Limit alcohol and caffeine: Reduce consumption of substances that may affect mood or sleep.",
              "Avoid substance use: Refrain from using drugs or alcohol as coping mechanisms.",
            ],
          ),
          TipCard(
            title: "Professional Help",
            tips: [
              "Therapy or counseling: Consider cognitive-behavioral therapy (CBT) or other forms of psychotherapy.",
              "Medication: Consult with healthcare providers for antidepressant or anti-anxiety medications if needed.",
              "Palliative care: Seek specialized support for managing symptoms and improving quality of life.",
            ],
          ),
          TipCard(
            title: "Mindfulness and Relaxation",
            tips: [
              "Practice mindfulness: Stay present and focused on the current moment to reduce anxiety and stress.",
              "Yoga or tai chi: Engage in activities that combine physical movement with mindfulness and relaxation.",
              "Journaling: Write down thoughts and emotions as a form of self-expression and reflection.",
            ],
          ),
        ],
      ),
    );
  }
}
