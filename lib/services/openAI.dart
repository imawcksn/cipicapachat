import 'package:http/http.dart' as http;

class OpenAIServices {
  String endpoint =
      'https://api.openai.com/v1/engines/gpt-3.5-turbo/completions';
  Future<String> getChatbotResponse(String userMessage) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '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'
      },
      body: '{"prompt": "$userMessage", "max_tokens": 150}',
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get chatbot response');
    }
  }
}
