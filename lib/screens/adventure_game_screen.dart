import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';

class AdventureGame extends StatelessWidget {
  const AdventureGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class Character {
  String name;
  String age;
  String background;
  List<String> inventory = [];

  Character({required this.name, required this.age, required this.background});

  void addToInventory(String item) {
    inventory.add(item);
  }

  List<String> showInventory() {
    return inventory;
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Character? character;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController backgroundController = TextEditingController();
  String currentState = 'start';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Journey Through History',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: getCurrentState(),
      ),
    );
  }

  Widget getCurrentState() {
    switch (currentState) {
      case 'start':
        return startState();
      case 'introduction':
        return introductionState();
      case 'firstChoice':
        return firstChoiceState();
      case 'joinProtest':
        return joinProtestState();
      case 'observeProtest':
        return observeProtestState();
      case 'secondChoice':
        return secondChoiceState();
      case 'volunteerEducation':
        return volunteerEducationState();
      case 'listenEducation':
        return listenEducationState();
      case 'thirdChoice':
        return thirdChoiceState();
      case 'exploreHarlem':
        return exploreHarlemState();
      case 'jazzClub':
        return jazzClubState();
      case 'conclusion':
        return conclusionState();
      default:
        return startState();
    }
  }

  Widget reusableTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget startState() {
    return Padding(
      key: const ValueKey('startState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome to "Journey Through History"!',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          reusableTextField(nameController, "Enter your character's name:"),
          const SizedBox(height: 10),
          reusableTextField(ageController, "Enter your character's age:"),
          const SizedBox(height: 10),
          reusableTextField(
              backgroundController, "Enter your character's background:"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                character = Character(
                  name: nameController.text,
                  age: ageController.text,
                  background: backgroundController.text,
                );
                currentState = 'introduction';
              });
            },
            child: const Text(
              'Start Adventure',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget introductionState() {
    return Padding(
      key: const ValueKey('introductionState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome, ${character!.name}!',
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text(
              'You are about to embark on a journey through significant moments in African American history.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text('Your choices will shape your experience. Let\'s begin!',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentState = 'firstChoice';
              });
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget firstChoiceState() {
    return Padding(
      key: const ValueKey('firstChoiceState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'You find yourself in the early 1960s during the Civil Rights Movement.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text('You see a group of people organizing a peaceful protest.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentState = 'joinProtest';
                    });
                  },
                  child: const Text('Join the protest'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentState = 'observeProtest';
                    });
                  },
                  child: const Text('Observe from a distance'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget joinProtestState() {
    character!.addToInventory('Protest Sign');
    return Padding(
      key: const ValueKey('joinProtestState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'You join the peaceful protest and march alongside others for equal rights.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text('You meet influential leaders and make new friends.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentState = 'secondChoice';
              });
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget observeProtestState() {
    return Padding(
      key: const ValueKey('observeProtestState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'You observe the protest from a distance, learning about the courage and determination of the participants.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text('You feel inspired to contribute in your own way.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentState = 'secondChoice';
              });
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget secondChoiceState() {
    return Padding(
      key: const ValueKey('secondChoiceState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Later, you find yourself at a community center where people are discussing ways to improve education.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentState = 'volunteerEducation';
                    });
                  },
                  child: const Text('Volunteer to help'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentState = 'listenEducation';
                    });
                  },
                  child: const Text('Listen to the discussion'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget volunteerEducationState() {
    character!.addToInventory('Education Flyer');
    return Padding(
      key: const ValueKey('volunteerEducationState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'You volunteer to help with the education initiative, tutoring children and organizing events.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text(
              'You gain valuable experience and make a positive impact on the community.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentState = 'thirdChoice';
              });
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget listenEducationState() {
    return Padding(
      key: const ValueKey('listenEducationState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'You listen to the discussion, gaining insights and understanding the challenges faced by the community.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text(
              'You feel motivated to continue supporting the cause in any way you can.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentState = 'thirdChoice';
              });
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget thirdChoiceState() {
    return Padding(
      key: const ValueKey('thirdChoiceState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Based on your background as a ${character!.background}, you decide to explore Harlem in the 1920s, during the Harlem Renaissance.',
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text(
              'You witness the flourishing of African American culture and arts.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentState = 'exploreHarlem';
                    });
                  },
                  child: const Text('Explore Harlem'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentState = 'jazzClub';
                    });
                  },
                  child: const Text('Visit a Jazz Club'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget exploreHarlemState() {
    character!.addToInventory('Art Piece');
    return Padding(
      key: const ValueKey('exploreHarlemState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'You explore the streets of Harlem, visiting art galleries and theaters.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text(
              'You meet artists, writers, and musicians, and immerse yourself in the vibrant culture.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentState = 'conclusion';
              });
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget jazzClubState() {
    character!.addToInventory('Jazz Record');
    return Padding(
      key: const ValueKey('jazzClubState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'You visit a jazz club, where you enjoy live performances by some of the greatest musicians of the era.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text(
              'The music inspires you and gives you a deeper appreciation for the cultural contributions of African Americans.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentState = 'conclusion';
              });
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget conclusionState() {
    return Padding(
      key: const ValueKey('conclusionState'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your journey through history has come to an end.',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Text(
              '${character!.name}, you have experienced significant moments and made meaningful contributions.',
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          const Text('Thank you for playing "Journey Through History"!',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Text('Your inventory: ${character!.showInventory().join(", ")}',
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentState = 'start';
                nameController.clear();
                ageController.clear();
                backgroundController.clear();
              });
            },
            child: const Text('Restart Game'),
          ),
        ],
      ),
    );
  }
}
