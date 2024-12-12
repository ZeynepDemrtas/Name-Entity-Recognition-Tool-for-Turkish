import 'package:bitirme_web/model/result.dart';
import 'package:flutter/cupertino.dart';

import '../api/result_api.dart';
import '../dependency_injection/locator.dart';
import '../model/data.dart';

class Repository {

  final _api = locator.get<RestClient>();


  Future<Result?> fetchResult(Data data) async {
    try {
      debugPrint('${data.chosenModel}');
      Result? response = await _api.getResult(data.sentences!,data.chosenModel!);
      debugPrint("REPO ${response.data}");
      return response;
    }
    catch (e) {
      debugPrint('REPO ERROR :  ${e.toString()}');
      return null;
    }
  }
}