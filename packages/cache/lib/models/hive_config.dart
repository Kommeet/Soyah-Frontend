import 'dart:io';

import 'package:cache/models/cash_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveConfig {
  static const String cacheBox = 'cacheBox';

  static Future<bool> initHiveDatabase() async {
    if (!kIsWeb) {
      Directory applicationDirectory = await getApplicationCacheDirectory();
      Hive.init(applicationDirectory.path);
    }
    Hive.registerAdapter(CashDataAdapter());
    return true;
  }

  Future<Box> openCacheBox() async {
    var hiveCacheBox = await Hive.openBox(cacheBox);
    return hiveCacheBox;
  }
}
