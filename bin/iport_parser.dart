import 'dart:io';

import 'package:iport_parser/services/watch_service.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

void main(List<String> arguments) async {
  var telegram = Telegram(Platform.environment['TG_BOT_TOKEN']!);
  var event = Event((await telegram.getMe()).username!);

  // TeleDart uses longpoll by default if no update fetcher is specified.
  var teledart = TeleDart(telegram, event);

  teledart.start();

  // You can listen to messages like this
  teledart
      .onMessage(
        entityType: 'bot_command',
        keyword: 'start',
      )
      .listen(
        (message) => teledart.telegram.sendMessage(
          message.chat.id,
          'Hello! Ask /watch and you can see available watch at IPort spb',
        ),
      );

  teledart.onCommand('watch').listen(
    ((message) async {
      teledart.replyMessage(message, 'Please wait ...');
      final watchList = await WatchService.watches();
      String messageText = watchList.join('\n');
      teledart.replyMessage(message, messageText);
    }),
  );
}
