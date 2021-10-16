import 'package:html/parser.dart';
import 'package:http/http.dart';

import '../models/watch.dart';

class WatchService {
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
          bool canBuy =
              item.children[3].children[0].children[1].children[0].text !=
                  'Предзаказ';
          watchList.add(Watch(title: title, price: price, canBuy: canBuy));
        } catch (_) {}
      }
    }
    return watchList;
  }
}
