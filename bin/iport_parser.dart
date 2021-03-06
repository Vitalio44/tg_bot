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
          'Hello! You can ask:\n'
          '/watch - and you can see available or not watch at IPort spb\n'
          '/chat_id - bot send this chat ID\n'
          '/notify - to subscribe and bot send message then watch be available',
        ),
      );

  teledart.onCommand('watch').listen(
    ((message) {
      teledart.replyMessage(message, 'Please wait ...');
      WatchService.watches().then((value) {
        teledart.replyMessage(
          message,
          value.map((e) => e.toMessage()).join('\n'),
        );
      });
    }),
  );

  teledart.onCommand('chat_id').listen(
        ((message) => teledart.replyMessage(message, '${message.chat.id}')),
      );

  teledart.onCommand('notify').listen(
    ((message) {
      teledart.replyMessage(
        message,
        'Ok! I send to this chat ${message.chat.id}, '
        'then you can buy apple watch 7 at IPort SPb',
      );
      WatchService.startWatch(teledart, message.chat.id);
    }),
  );
}
