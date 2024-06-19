import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/widgets/tip_card.dart';

class WeaknessManagementWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: Text('Weakness Management Tips'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TipCard(
            title: "Nutrition",
            tips: const [
              "Eat small, frequent meals: This can help maintain energy levels throughout the day.",
              "Include protein-rich foods: Protein helps build and repair tissues, promoting strength and endurance.",
              "Stay hydrated: Dehydration can contribute to feelings of weakness, so drink plenty of fluids.",
            ],
          ),
          TipCard(
            title: "Exercise and Activity",
            tips: const [
              "Low-impact exercises: Activities like walking, swimming, or yoga can improve strength and stamina without causing excessive fatigue.",
              "Strength training: Light resistance exercises can help build muscle strength and improve overall energy levels.",
              "Balance activities: Exercises that improve balance can prevent falls and increase confidence in daily activities.",
            ],
          ),
          TipCard(
            title: "Rest and Sleep",
            tips: const [
              "Prioritize rest: Allow yourself time to rest between activities to conserve energy.",
              "Establish a sleep routine: Aim for consistent sleep and wake times to promote better sleep quality.",
              "Create a comfortable sleep environment: Ensure your bedroom is conducive to restful sleep, with minimal noise and distractions.",
            ],
          ),
          TipCard(
            title: "Mind-Body Techniques",
            tips: const [
              "Relaxation techniques: Practice deep breathing, meditation, or progressive muscle relaxation to reduce stress and conserve energy.",
              "Mindfulness: Stay present and focus on the moment to manage stress and improve overall well-being.",
              "Yoga or Tai Chi: These practices combine movement, breathing, and meditation to promote relaxation and improve strength.",
            ],
          ),
          TipCard(
            title: "Assistive Devices",
            tips: const [
              "Use supportive footwear: Comfortable shoes with good arch support can reduce fatigue and improve mobility.",
              "Consider mobility aids: Devices like canes or walkers can provide stability and conserve energy during daily activities.",
              "Adaptive equipment: Tools designed for specific tasks, such as ergonomic kitchen utensils or reachers, can make activities easier.",
            ],
          ),
          TipCard(
            title: "Medical Management",
            tips: const [
              "Manage underlying conditions: Treatments for chronic illnesses or conditions contributing to weakness, such as anemia or heart disease, can improve energy levels.",
              "Medication review: Consult with healthcare providers to adjust medications that may cause fatigue or weakness as a side effect.",
              "Pain management: Addressing pain through medications or therapies can reduce fatigue associated with discomfort.",
            ],
          ),
          TipCard(
            title: "Emotional Support",
            tips: const [
              "Seek counseling or therapy: Discussing feelings of fatigue and managing emotional stress can improve overall well-being.",
              "Join support groups: Connecting with others facing similar challenges can provide encouragement and practical tips for managing weakness.",
              "Stay socially engaged: Maintaining relationships and participating in activities you enjoy can boost mood and energy levels.",
            ],
          ),
        ],
      ),
    );
  }
}
