import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supa_app/constants/constants.dart';

class TelegramBot {
  final String botToken;
  final String apiUrl;

  TelegramBot(this.botToken)
      : apiUrl = 'https://api.telegram.org/bot$botToken/';

  Future<void> sendMessage(int chatId, String message) async {
    final url = Uri.parse('${apiUrl}sendMessage');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'chat_id': chatId,
        'text': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message: ${response.body}');
    }
  }

  Future<List<dynamic>> getUpdates([int? offset]) async {
    final url = Uri.parse('${apiUrl}getUpdates');
    final response = await http.get(
      url.replace(queryParameters: {'offset': offset?.toString()}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'];
    } else {
      throw Exception('Failed to fetch updates: ${response.body}');
    }
  }
}

void startTelegramBot() async {
  final bot = TelegramBot(tgBotToken);
  int? lastUpdateId;

  while (true) {
    try {
      final updates = await bot.getUpdates(lastUpdateId);

      for (final update in updates) {
        final message = update['message'];
        final chatId = message['chat']['id'];
        final text = message['text'];

        if (text == '/link') {
          await bot.sendMessage(chatId, 'Вот ваша ссылка: $siteLink');
        }

        lastUpdateId = update['update_id'] + 1;
      }
    } catch (e) {
      print('Ошибка: $e');
    }

    await Future.delayed(Duration(seconds: 1));
  }
}
