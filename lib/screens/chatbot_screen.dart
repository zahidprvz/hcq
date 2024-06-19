import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hcq/resources/firestore_methods.dart';
import 'package:hcq/utils/colors.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

const String _intentsFile = "assets/intents.json";
const String _modelFile = "assets/medical_chatbot_model.tflite";
const String _wordsFile = "assets/words.json";
const String _classesFile = "assets/classes.json";

class ChatBotScreen extends StatefulWidget {
  final String uid;

  const ChatBotScreen({super.key, required this.uid});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: message.isUser ? 40 : 10,
        right: message.isUser ? 10 : 40,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: message.isUser ? Colors.blue[300] : Colors.grey[300],
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: message.isUser ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  Interpreter? _interpreter;
  Map<String, dynamic> _intents = {};
  List<ChatMessage> _messages = [];
  List<String> _words = [];
  List<String> _classes = [];
  final ScrollController _scrollController = ScrollController();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadIntents();
    _loadWords();
    _loadClasses();
    _loadChatHistory();
  }

  void _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelFile);
      if (kDebugMode) {
        print("Interpreter loaded successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to load interpreter: $e");
      }
    }
  }

  void _loadIntents() async {
    try {
      String data = await rootBundle.loadString(_intentsFile);
      _intents = json.decode(data);
      if (kDebugMode) {
        print("Intents loaded successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to load intents: $e");
      }
    }
  }

  void _loadWords() async {
    try {
      String data = await rootBundle.loadString(_wordsFile);
      _words = List<String>.from(json.decode(data));
      if (kDebugMode) {
        print("Words loaded successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to load words: $e");
      }
    }
  }

  void _loadClasses() async {
    try {
      String data = await rootBundle.loadString(_classesFile);
      _classes = List<String>.from(json.decode(data));
      if (kDebugMode) {
        print("Classes loaded successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to load classes: $e");
      }
    }
  }

  void _loadChatHistory() {
    _firestoreMethods.loadChatWithChatbot(widget.uid).listen((messageList) {
      setState(() {
        _messages = messageList.map((message) {
          return ChatMessage(
            text: message.text,
            isUser: message.senderId == widget.uid,
          );
        }).toList();
      });
      // Ensure the list scrolls to the bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });
  }

  List<String> _findMatchingIntents(String message) {
    List<String> matchingIntents = [];

    List<double> results = _predict(message);

    for (var i = 0; i < results.length; i++) {
      var response = results[i];
      if (response >= 0.5) {
        matchingIntents.add(_classes[i]);
      }
    }

    return matchingIntents;
  }

  List<double> _predict(String message) {
    List<double> results = List.filled(_classes.length, 0.0);

    if (_interpreter == null) {
      if (kDebugMode) {
        print("Interpreter not initialized.");
      }
      return results;
    }

    var input = _bagOfWords(message.toLowerCase());

    try {
      var inputArray =
          Float32List.fromList(input.map((e) => e.toDouble()).toList());
      var output =
          List.filled(_classes.length, 0.0).reshape([1, _classes.length]);
      _interpreter!.run(inputArray, output);
      results = output[0];
    } catch (e) {
      if (kDebugMode) {
        print("Error running interpreter: $e");
      }
    }

    return results;
  }

  List<int> _bagOfWords(String message) {
    List<int> bag = List.filled(_words.length, 0);

    var words = message.split(' ');
    for (var word in words) {
      if (_words.contains(word)) {
        bag[_words.indexOf(word)] = 1;
      }
    }

    return bag;
  }

  void _sendMessage(String message) async {
    List<ChatMessage> chatHistory = [];
    chatHistory.add(ChatMessage(text: message, isUser: true));
    List<String> matchedIntents = _findMatchingIntents(message);

    setState(() {
      _messages.insert(0, ChatMessage(text: message, isUser: true));

      if (matchedIntents.isNotEmpty) {
        for (var intentTag in matchedIntents) {
          var intent = _intents["intents"].firstWhere(
              (element) => element["tag"] == intentTag,
              orElse: () => {});
          if (intent.containsKey("responses")) {
            List<String> responses = List<String>.from(intent["responses"]);
            for (var response in responses) {
              chatHistory.add(ChatMessage(text: response, isUser: false));
              _messages.insert(0, ChatMessage(text: response, isUser: false));
            }
          }
        }
      } else {
        String defaultMessage = "Sorry, I'm not sure how to respond to that.";
        chatHistory.add(ChatMessage(text: defaultMessage, isUser: false));
        _messages.insert(
            0,
            ChatMessage(
              text: defaultMessage,
              isUser: false,
            ));
      }
    });

    // Store both user's message and chatbot responses in Firestore
    String storeResult = await _firestoreMethods.storeUserChatWithChatbot(
        widget.uid, chatHistory);
    if (kDebugMode) {
      print("Store Result: $storeResult");
    }

    // Scroll to the end of the list when new message is added
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _deleteChat() async {
    await _firestoreMethods.deleteChatWithChatbot(widget.uid);

    setState(() {
      _messages.clear();
    });

    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    if (_interpreter != null) {
      _interpreter!.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('Chat with Chatbot'),
        actions: [
          PopupMenuButton<String>(
            color: mobileBackgroundColor,
            shadowColor: Colors.white,
            onSelected: (String result) {
              if (result == 'delete') {
                _deleteChat();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete Chat',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: theme.colorScheme.secondary,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: secondaryColor,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: secondaryColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: secondaryColor,
                  ),
                  onPressed: () {
                    String message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
