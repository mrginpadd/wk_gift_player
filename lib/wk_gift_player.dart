import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vap/flutter_vap.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'src/wk_gift_video_model.dart';
part 'src/wk_loader.dart';
part 'src/wk_player.dart';

class WKGiftPlayer {
  static init({List<Map<String, dynamic>>? giftJson}) {
    if (giftJson != null) {
      _WKVideoLoader.instance.updateGiftJson(giftJson);
    }
  }

  static playGift(
    BuildContext context, {
    required String key,
    Function(Map<dynamic, dynamic>?)? callback,
  }) {
    _WKPlayer.instance.playGiftKey(
      context: context,
      key: key,
      callback: callback,
    );
  }
}
