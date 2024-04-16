import 'package:flutter_gpt_/env/env.dart';
import 'package:openai_api/openai_api.dart';

class ChatGPTService {
  final client = OpenaiClient(
    config: OpenaiConfig(
      apiKey: Env.apiKey, // 你的key
      // baseUrl: "",
      // httpProxy: "",
    ),
  );

  Future<ChatCompletionResponse> sendChat(String content) async {
    final request = ChatCompletionRequest(model: Models.gpt3_5Turbo, messages: [
      ChatMessage(
        content: content,
        role: ChatMessageRole.user,
      )
    ]);
    return await client.sendChatCompletion(request);
  }
}
