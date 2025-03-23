part of '../wk_gift_player.dart';

class _WKGiftVideoModel {
  _WKGiftVideoModel({required this.key, required this.url})
    : assert(key.isNotEmpty, '_GiftVideoModel Key must not be empty'),
      assert(url.isNotEmpty, '_GiftVideoModel URL must not be empty');

  final String key;
  final String url;

  factory _WKGiftVideoModel.fromJson(Map<String, dynamic> json) {
    final key = json['key'] as String?;
    final url = json['url'] as String?;

    if (key == null || key.isEmpty) {
      throw ArgumentError('_GiftVideoModel Key must not be null or empty');
    }
    if (url == null || url.isEmpty) {
      throw ArgumentError('_GiftVideoModel URL must not be null or empty');
    }

    return _WKGiftVideoModel(key: key, url: url);
  }
}
