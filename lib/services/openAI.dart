import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIServices {
  String endpoint =
      'https://api.openai.com/v1/engines/gpt-3.5-turbo/completions';
  Future<String> getChatbotResponse(String userMessage) async {
    final token = await dotenv.env['API_TOKEN'];
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json', 'Authorization': token!},
      body: '{"prompt": "$userMessage", "max_tokens": 150}',
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get chatbot response');
    }
  }
}
