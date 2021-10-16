import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:teledart/teledart.dart';

import '../models/watch.dart';

class WatchService {
  static bool _isLoopStart = false;
  static List<int> _chatIdList = [];

  static Future<List<Watch>> watches() async {
    final response = await Client().get(Uri.parse(
      'https://www.iport.ru/catalog/apple_watch/filter/razmer_korpusa-is-45_mm/',
    ));
    List<Watch> watchList = [];
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final catalog = document.getElementById('js-catalog-block-ajax');
      for (var item in catalog!.children) {
        try {
          String title = item.children[1].children[0].text.trim();
          String price = item
              .children[3].children[0].children[0].children[0].children[1].text;
          String imageUrl =
              item.children[2].children[0].children[0].attributes['src']!;
          bool canBuy =
              item.children[3].children[0].children[1].children[0].text !=
                  'Предзаказ';
          watchList.add(Watch(
            title: title,
            price: price,
            canBuy: canBuy,
            imageUrl: 'https://www.iport.ru$imageUrl',
          ));
        } catch (_) {}
      }
    }
    return watchList;
  }

  static startWatch(TeleDart teledart, int chatId) async {
    if (!_chatIdList.contains(chatId)) _chatIdList.add(chatId);
    if (!_isLoopStart) {
      _isLoopStart = true;
      while (true) {
        List<Watch> watchList = await WatchService.watches();
        List<Watch> availableWatchList =
            watchList.where((element) => element.canBuy).toList();
        if (availableWatchList.isNotEmpty) {
          for (var userChatId in _chatIdList) {
            teledart.telegram.sendMessage(
              userChatId,
              'Hi!\nIPort have available Apple Watch 7!',
            );
            teledart.telegram.sendMessage(
              userChatId,
              availableWatchList.map((e) => e.toMessage()).join('\n'),
            );
          }
        }
        Future.delayed(Duration(hours: 4));
      }
    }
  }
}
