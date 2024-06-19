import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/widgets/tip_card.dart';

class PainManagementWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('Pain Management Tips'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TipCard(
            title: "Medication Management",
            tips: const [
              "Pain Relievers: Over-the-counter medications like acetaminophen or NSAIDs can be helpful for mild pain. For more severe pain, prescription opioids or other stronger pain medications may be necessary.",
              "Antispasmodics: Medications to reduce bowel spasms can help alleviate cramping and abdominal pain.",
              "Neuropathic Pain Medications: If the pain is nerve-related, medications like gabapentin or pregabalin may be prescribed.",
            ],
          ),
          TipCard(
            title: "Nutritional Support",
            tips: const [
              "Low-Fiber Diet: A low-fiber diet can help reduce bowel movements and ease symptoms like diarrhea and cramping.",
              "Small, Frequent Meals: Eating smaller meals more frequently can prevent bloating and discomfort.",
              "Hydration: Ensure adequate fluid intake to prevent dehydration and constipation.",
            ],
          ),
          TipCard(
            title: "Physical Activity",
            tips: const [
              "Gentle Exercise: Light activities such as walking or yoga can help improve digestion and reduce pain.",
              "Pelvic Floor Exercises: These can strengthen the muscles around the colon and help alleviate some pain.",
            ],
          ),
          TipCard(
            title: "Stress Management",
            tips: const [
              "Relaxation Techniques: Practices like deep breathing, meditation, and progressive muscle relaxation can help reduce pain by decreasing stress levels.",
              "Cognitive Behavioral Therapy (CBT): This can help change the way pain is perceived and improve coping mechanisms.",
            ],
          ),
          TipCard(
            title: "Alternative Therapies",
            tips: const [
              "Acupuncture: This traditional Chinese medicine technique can help reduce pain and improve overall well-being.",
              "Massage Therapy: Gentle massage can help alleviate muscle tension and pain.",
            ],
          ),
          TipCard(
            title: "Medical Procedures",
            tips: const [
              "Nerve Blocks: In cases of severe pain, nerve blocks may be used to interrupt pain signals.",
              "Epidural Injections: These can provide relief for certain types of back and abdominal pain.",
            ],
          ),
          TipCard(
            title: "Bowel Management",
            tips: const [
              "Stool Softeners and Laxatives: These can help manage constipation and prevent straining during bowel movements.",
              "Enemas or Suppositories: These may be used under medical supervision to relieve severe constipation.",
            ],
          ),
          TipCard(
            title: "Supportive Care",
            tips: const [
              "Support Groups: Joining a support group for cancer patients can provide emotional support and practical advice.",
              "Palliative Care: Specialized medical care focused on providing relief from symptoms and improving quality of life.",
            ],
          ),
          TipCard(
            title: "Home Comfort Measures",
            tips: const [
              "Heat Therapy: Applying a heating pad or warm compress to the abdomen can help reduce pain.",
              "Positioning: Finding comfortable positions that relieve pressure on the abdomen, such as lying on your side with a pillow between your knees.",
            ],
          ),
          TipCard(
            title: "Communication with Healthcare Providers",
            tips: const [
              "Regular Check-ins: Keep in regular contact with your healthcare team to adjust pain management strategies as needed.",
              "Symptom Tracking: Keep a diary of your pain and other symptoms to help your healthcare provider make informed decisions about your care.",
            ],
          ),
          TipCard(
            title: "Pain Management Plans",
            tips: const [
              "Individualized Plans: Work with your healthcare team to develop a personalized pain management plan that addresses your specific needs and preferences.",
            ],
          ),
          TipCard(
            title: "Psychological Support",
            tips: const [
              "Counseling: Professional counseling can help address the emotional aspects of dealing with chronic pain and cancer.",
              "Mindfulness and Meditation: These practices can help manage pain perception and improve mental health.",
            ],
          ),
        ],
      ),
    );
  }
}
