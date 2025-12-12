import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyAA95KekVTOLG5tOJQzeykzjASeuYL2giU';
  static late GenerativeModel _model;

  static void initialize() {
    _model = GenerativeModel(model: 'models/gemini-pro', apiKey: _apiKey);
  }

  static Future<String> generateResponse(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Sorry, I couldn\'t generate a response.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  static Future<String> generateShoppingResponse(String prompt) async {
    try {
      final shoppingPrompt =
          '''
You are NexBuy AI Assistant, a helpful shopping assistant for an e-commerce app. 
You help users with product recommendations, shopping advice, and general questions about technology products, especially laptops and electronics.

User question: $prompt

Please provide a helpful, friendly response that's relevant to shopping and technology products. Keep responses concise but informative.
''';

      final content = [Content.text(shoppingPrompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Sorry, I couldn\'t help with that.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
