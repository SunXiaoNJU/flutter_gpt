import 'package:flutter/material.dart';
import 'package:flutter_gpt_/models/message.dart';
import 'package:flutter_gpt_/services/injection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../state/message_state.dart';
import 'message_item.dart';

class ChatScreen extends HookConsumerWidget {
  ChatScreen({super.key});

  final _textController = TextEditingController();

  _requestChatGPT(WidgetRef ref, String content) async {
    final res = await chatgpt.sendChat(content);
    final text = res.choices.first.message?.content ?? "";
    final message =
        Message(content: text, isUser: false, timestamp: DateTime.now());
    ref.read(messageProvider.notifier).addMessage(message);
  }

  _sendMessage(WidgetRef ref, String content) {
    final message =
        Message(content: content, isUser: true, timestamp: DateTime.now());
    ref.read(messageProvider.notifier).addMessage(message); // 添加消息
    _textController.clear();
    _requestChatGPT(ref, content);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageProvider); // 获取数据
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Chat'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return MessageItem(message: messages[index]);
                },
                itemCount: messages.length, // 消息数量
                separatorBuilder: (context, index) => const Divider(
                  // 分割线
                  height: 20,
                ),
              ),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                  hintText: 'Type a message', // 显示在输入框内的提示文字
                  suffixIcon: IconButton(
                    onPressed: () {
                      // 这里处理发送事件
                      if (_textController.text.isNotEmpty) {
                        _sendMessage(ref, _textController.text);
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
