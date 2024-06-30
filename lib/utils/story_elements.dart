class StoryElement {
  String questionText;
  List<String> choices;
  int correctAnswerIndex;

  StoryElement(
      {required this.questionText,
      required this.choices,
      required this.correctAnswerIndex});
}

class StoryElements {
  static List<StoryElement> storyData = [
    StoryElement(
      questionText:
          "Who was the first African American to win an Olympic gold medal?",
      choices: ["Alice Coachman", "Jesse Owens", "Wilma Rudolph", "Carl Lewis"],
      correctAnswerIndex: 1,
    ),
    StoryElement(
      questionText:
          "Which African American musician is known as the 'King of Pop'?",
      choices: ["Michael Jackson", "Prince", "Stevie Wonder", "James Brown"],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "Who was the first African American to serve as the President of the United States?",
      choices: [
        "Barack Obama",
        "Martin Luther King Jr.",
        "Frederick Douglass",
        "Jesse Jackson"
      ],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "Who is the first African American woman to win the Nobel Prize in Literature?",
      choices: [
        "Toni Morrison",
        "Maya Angelou",
        "Alice Walker",
        "Octavia Butler"
      ],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "Which African American scientist developed the first successful open-heart surgery technique?",
      choices: [
        "Daniel Hale Williams",
        "Charles Drew",
        "Percy Julian",
        "George Washington Carver"
      ],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "Who was the first African American to win the Academy Award for Best Actor?",
      choices: [
        "Sidney Poitier",
        "Denzel Washington",
        "Jamie Foxx",
        "Forest Whitaker"
      ],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "Which African American athlete broke the color barrier in Major League Baseball?",
      choices: [
        "Jackie Robinson",
        "Hank Aaron",
        "Willie Mays",
        "Satchel Paige"
      ],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "Who is the first African American woman to be elected to the United States Congress?",
      choices: [
        "Shirley Chisholm",
        "Kamala Harris",
        "Maxine Waters",
        "Barbara Jordan"
      ],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "Which African American poet wrote the famous poem 'Still I Rise'?",
      choices: [
        "Maya Angelou",
        "Langston Hughes",
        "Gwendolyn Brooks",
        "Nikki Giovanni"
      ],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "Who is the first African American to win the Pulitzer Prize for Fiction?",
      choices: [
        "Alice Walker",
        "Toni Morrison",
        "Colson Whitehead",
        "Ralph Ellison"
      ],
      correctAnswerIndex: 1,
    ),
    // Add more trivia questions as needed
    StoryElement(
      questionText:
          "What age should African Americans start getting regular colorectal screenings?",
      choices: ["45", "50", "55", "60"],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "What are some common risk factors for colorectal cancer in African Americans?",
      choices: ["Obesity", "Smoking", "Diet", "All of the above"],
      correctAnswerIndex: 3,
    ),
    StoryElement(
      questionText:
          "True or False: Colorectal cancer is the third most common cancer in African American men and women.",
      choices: ["True", "False"],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "What are some signs and symptoms of colorectal cancer that African Americans should be aware of?",
      choices: [
        "Blood in stool",
        "Unexplained weight loss",
        "Change in bowel habits",
        "All of the above"
      ],
      correctAnswerIndex: 3,
    ),
    StoryElement(
      questionText:
          "Name one lifestyle factor that can help reduce the risk of colorectal cancer in African Americans.",
      choices: [
        "Regular exercise",
        "High-fat diet",
        "Smoking",
        "High alcohol consumption"
      ],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "Why is early detection important for colorectal cancer in African Americans?",
      choices: [
        "Higher survival rates",
        "Lower treatment costs",
        "Less invasive treatments",
        "All of the above"
      ],
      correctAnswerIndex: 3,
    ),
    StoryElement(
      questionText:
          "Name one type of colorectal screening test that is recommended for African Americans.",
      choices: ["Colonoscopy", "Blood test", "MRI", "X-ray"],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "What are some common myths or misconceptions about colorectal screening in the African American community?",
      choices: [
        "It's painful",
        "It's unnecessary",
        "It's expensive",
        "All of the above"
      ],
      correctAnswerIndex: 3,
    ),
    StoryElement(
      questionText:
          "True or False: African Americans have a higher incidence and mortality rate for colorectal cancer compared to other racial/ethnic groups in the United States.",
      choices: ["True", "False"],
      correctAnswerIndex: 0,
    ),
    StoryElement(
      questionText:
          "How can African Americans overcome barriers to colorectal screening and increase participation?",
      choices: [
        "Education and awareness",
        "Access to healthcare",
        "Community support",
        "All of the above"
      ],
      correctAnswerIndex: 3,
    ),
  ];
}
