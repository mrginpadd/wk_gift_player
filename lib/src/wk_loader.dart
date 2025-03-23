part of '../wk_gift_player.dart';

class _WKVideoLoader {
  static final instance = _WKVideoLoader._();

  final _videos = <_WKGiftVideoModel>{};
  List<Map<String, dynamic>> _giftJson = _defaultGiftJson;

  _WKVideoLoader._();

  void updateGiftJson(List<Map<String, dynamic>> newGiftJson) {
    _giftJson = newGiftJson;
    _videos.clear();
  }

  Future<void> _loadVideoMetaDataIfNeeded() async {
    if (_videos.isNotEmpty) return;
    final videos = _giftJson.map((e) => _WKGiftVideoModel.fromJson(e)).toList();

    _videos.addAll(videos);
  }

  Future<String> loadVideo({required String key}) async {
    final videoPath = await _getVideoFilepath(key);
    final fileExists = await File(videoPath).exists();

    if (fileExists) {
      return videoPath;
    }

    return await _downloadVideo(key);
  }

  Future<String> _getVideoFilepath(String key) async {
    final cacheDir = await getApplicationCacheDirectory();
    final videoUrl = await _getVideoUrl(key);
    final extension = p.extension(videoUrl);
    return p.join(cacheDir.path, '$key$extension');
  }

  Future<String> _downloadVideo(String key) async {
    final url = await _getVideoUrl(key);
    final savedPath = await _getVideoFilepath(key);

    final rep = await Dio().download(url, savedPath);
    if (rep.statusCode == 200) {
      debugPrint('Download video successfully: $savedPath');
      return savedPath;
    } else {
      return Future.error('Download video failed for key: $key.');
    }
  }

  Future<String> _getVideoUrl(String key) async {
    try {
      await _loadVideoMetaDataIfNeeded();
      return _videos.firstWhere((e) => e.key == key).url;
    } catch (err) {
      return Future.error('Video for key [$key] does not exist.');
    }
  }

  static const _defaultGiftJson = [
    {
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1710906665366/MISS_YOU_GIFT.mp4",
      "key": "MISS_YOU_GIFT",
    },
    {
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1710904092121/CANDY_GIFT.mp4",
      "key": "CANDY_GIFT",
    },
    {
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1710906624064/LOVEU_GIFT.mp4",
      "key": "LOVEU_GIFT",
    },
    {
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1710906481697/FLIGHT_GIFT.mp4",
      "key": "FLIGHT_GIFT",
    },
    {
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1710906547938/HUT_GIFT.mp4",
      "key": "HUT_GIFT",
    },
    {
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1667904810141/1108_hcxy.mp4",
      "key": "PACKET_GIFT",
    },
    {
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1664530268465/930_xdxl.mp4",
      "key": "MAN_FL_GIFT",
    },
    {
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1666594446575/1024_dqjz.mp4",
      "key": "MAN_FL_GIFT_2",
    },
    {
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1643098434111/125_xdqkl.mp4",
      "key": "WOMAN_QKL_GIFT",
    },
    {
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1645079809231/nl_im_gift_aiqing_shu_send.mp4",
      "key": "WOMAN_QKL_GIFT_2",
    },
    {
      "key": "BRACELET_GIFT",
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1678334246183/yuzhuo.mp4",
    },
    {
      "key": "EARRINGS_GIFT",
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1671800560735/1223_zzeh.mp4",
    },
    {
      "key": "RING_GIFT",
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1689855381751/video.mp4",
    },
    {
      "key": "BIRTHDAY_GIFT",
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1709539990927/4226_%E4%B8%BA%E5%A5%B3%E7%A5%9E%E7%8C%AE%E7%A4%BCMP4.mp4",
    },
    {
      "key": "KISSYOU_GIFT",
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1699432883394/video.mp4",
    },
    {
      "key": "LOVERS_GIFT",
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1702954322708/1335_mute.mp4",
    },
    {
      "key": "LoveArrow_GIFT",
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1691564247107/video.mp4",
    },
    {
      "key": "Lipstick_GIFT",
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1695011250278/video.mp4",
    },
    {
      "key": "DreamMoon_GIFT",
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1725884842360/video.mp4",
    },
    {
      "key": "DreamyCastle_GIFT",
      "url":
          "https://res-cdn.nuan.chat/dynamic-effect-resource/mp4/1636530497419/video.mp4",
    },
  ];
}
