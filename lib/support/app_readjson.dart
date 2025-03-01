import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/services.dart';

class AppReadJsonHelper {
  Future<Map<String, dynamic>> readJson({
    required String asset
  }) async {
    final String response = await rootBundle.loadString(asset);
    // final String response = await rootBundle.loadString('assets/sample.json');
    // AppLoggerCS.debugLog("here1 $response");
    final data = await json.decode(response);
    // AppLoggerCS.debugLog("here2 $data");
    return data;
  }
}
