import 'package:flutter/material.dart';

import 'package:searchimage/model/search_model.dart';
import 'package:searchimage/service/network_service.dart';

class MyHomeViewModel extends ChangeNotifier {
  bool loader = true;
  List<Hits> hits = [];
  List<Hits> lazyloading = [];
  Future getSearch(BuildContext context, String name) async {
    loader = true;
    var searchList = await NetworkService().get({}, context, name);

    SearchModel searchdata = SearchModel.fromJson(searchList);
    hits = searchdata.hits;

    if (hits.length < 5) {
      lazyloading = hits;
    } else {
      lazyloading = hits.sublist(0, 5);
    }

    loader = false;
    notifyListeners();
    return searchList;
  }
}
