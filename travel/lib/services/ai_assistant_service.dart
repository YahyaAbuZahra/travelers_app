import 'dart:async';
import 'dart:math';

class AIAssistantService {
  static final AIAssistantService _instance = AIAssistantService._internal();
  factory AIAssistantService() => _instance;
  AIAssistantService._internal();

  Future<String> sendMessage(String message, {String? context}) async {
    await Future.delayed(Duration(milliseconds: 800));

    final responses = [
      "I can help you find amazing travel destinations! What type of place are you looking for?",
      "Based on your interests, I recommend checking out our trending places section.",
      "Would you like me to suggest some popular tourist attractions?",
      "I can provide information about local culture, food, and activities.",
      "Let me help you plan your perfect trip! What's your budget range?",
      "Are you interested in historical sites, nature, or modern attractions?",
    ];

    return responses[Random().nextInt(responses.length)];
  }

  List<String> getSuggestions() {
    return [
      "Popular destinations",
      "Budget travel tips",
      "Local restaurants",
      "Weather updates",
      "Transportation options",
      "Cultural activities",
    ];
  }
}
